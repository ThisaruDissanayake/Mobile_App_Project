import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/controllers/product_provider.dart';
import 'package:frontend/models/sneaker_models.dart';
import 'package:frontend/services/helper.dart';
import 'package:frontend/views/Ui/product_page.dart';
import 'package:frontend/views/shared/appstyle.dart';
//import 'package:frontend/views/shared/appstyle.dart';
import 'package:frontend/views/shared/custom_field.dart';
import 'package:frontend/views/shared/reusable_text.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductNotifier>(context);

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 100.h,
              backgroundColor: Colors.black,
              elevation: 0,
              title: CustomField(
                hintText: 'Search for a product',
                controller: search,
                onEditingComplete: () {
                  setState(() {});
                },
                prefixIcon: GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: const Icon(Icons.search, color: Colors.black),
                ),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 249, 223, 237),
            body: search.text.isEmpty
                ? Container(
                    height: 600.h,
                    padding: EdgeInsets.all(20.h),
                    margin: EdgeInsets.only(right: 50.h),
                    child: Image.asset('assets/images/Pose23.png'),
                  )
                : FutureBuilder<List<Sneakers>>(
                    future: Helper().search(search.text),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: reusableText(
                              text: 'Error Retriving the data',
                              style:
                                  appstyle(20, Colors.black, FontWeight.bold)),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        return Center(
                          child: reusableText(
                              text: 'Product not found',
                              style:
                                  appstyle(20, Colors.black, FontWeight.bold)),
                        );
                      } else {
                        final creams = snapshot.data;
                        return ListView.builder(
                            itemCount: creams!.length,
                            itemBuilder: ((context, index) {
                              final cream = creams[index];
                              return GestureDetector(
                                onTap: () {
                                  productProvider.branchers = cream.branches;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductPage(sneakers: cream)));
                                },
                                child:Padding(padding: EdgeInsets.all(8.h),
                                child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child:Container(
                                  height: 100.h,
                                  width:325,
                                  decoration: BoxDecoration(
                                    color:Colors.grey.shade100,
                                    boxShadow:[
                                      BoxShadow(
                                    color:Colors.grey.shade500,
                                    spreadRadius:5,
                                    blurRadius:0.3,
                                    offset: const Offset(0,1))
                                    ]
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(padding:EdgeInsets.all(12.h),
                                            child: CachedNetworkImage(
                                            imageUrl:cream.imageUrl[0],
                                            width:70.w,
                                            height: 70.h,
                                            fit:BoxFit.cover,),
                                              ),
                                            
                                              Padding(padding:EdgeInsets.only(top: 12.h, left: 10.w),
                                               child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children:[
                                                  reusableText(text: cream.name, 
                                                  style: appstyle(16, Colors.black, FontWeight.w600)),
                                                  const SizedBox(
                                                    height:5,
                                                  ),
                                            
                                                  reusableText(text: cream.category, 
                                                  style: appstyle(13, Colors.grey.shade600, FontWeight.w600)),
                                            
                                                  const SizedBox(
                                                    height:5,
                                                  ),
                                            
                                                  reusableText(text: "\$ ${cream.price}", 
                                                  style: appstyle(13, Colors.grey.shade600, FontWeight.w600))
                                            
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                      )
                                ))
                                )
                              );
                            }));
                      }
                    })));
  }
}