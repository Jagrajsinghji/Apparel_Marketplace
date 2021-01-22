import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PageShimmer extends StatelessWidget {
  const PageShimmer();
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Colors.grey.shade400,
            Colors.white60,
            Colors.redAccent.withOpacity(.5),
            Colors.grey.shade200,
            Colors.grey.shade400
          ],
          stops: const <double>[
            0.0,
            0.35,
            0.45,
            0.55,
            1.0
          ]),
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 200,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              height: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, right: 10, left: 10),
            child: Container(
              height: 400,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ...List.generate(2, (index) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        child: GridView(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: .85),
                          scrollDirection: Axis.vertical,
                          children: List.generate(4, (index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  }),
                  Container(
                    width: 40,
                    child: Icon(Icons.double_arrow_rounded),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5.0, right: 10, left: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              height: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              height: 240,
              child: ListView.builder(
                  itemCount: 6,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 10, right: 2, left: 2),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5.0, right: 10, left: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              height: 40,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
            child: GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .8,
                  crossAxisCount: 2,
                ),
                itemBuilder: (c, i) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
