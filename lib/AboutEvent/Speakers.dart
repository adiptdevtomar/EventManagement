import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Speakers extends StatefulWidget {
  @override
  _SpeakersState createState() => _SpeakersState();
}

class _SpeakersState extends State<Speakers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                "Aashna Shroff",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Fashion, Travel & Lifestyle blogger",
                style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey.shade500),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                  "An Indian fashion, travel and lifestyle blogger and perhaps the most famous fashion vlogger in India. Being an entrepreneur, she also has an online store The Snob Shop that is an extension of her own approach to fashion. Winner of the People’s Choice Award for Best Urban Style 2017 also the nominee for Cosmopolitan India Blogger Awards 2018, and has a swarm of huge followers on social media."),
              SizedBox(
                height: 25.0,
              ),
              Text(
                "Ashish Sulkh",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Photographer, Traveler",
                style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey.shade500),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                  "A Photographer who works with WWF India, NBA and Incredible India, Google and National Geographic. Traveling to the deepest corners of India as well as other countries with just a camera in hand, has always been his hobby, career and life."),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Deepti Sharma",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Entrepreneur",
                style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey.shade500),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                  "Since childhood, Deepti Sharma was curious about new business ideas, and was yearning to become an entrepreneur. She pursued her CA and worked with firms like Ernst & Young, but her entrepreneurial spirit never let her feel settled. After two years, she quit her job to start something of her own. She started her journey online startup failed miserably. Instead of losing hope, she used the stumbling blocks in her life as a learning which made her much more willing to take risks. "),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Gaurav Taneja",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Fitness Expert, Pilot, Vlogger",
                style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey.shade500),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                  "Gaurav Taneja An aviator, Captain at Indigo, Civil Engineer from IIT Kharagpur, National Pro Athlete (IBBF) , A certified nutritionist, fitness expert and a vlogger. Known for giving logical and scientific information about fitness, he has gained over 800k subscribers over a short span of time for his Channel 'FitMuscle TV'. A man with a great sense of humour, unique storytelling ability he also took his vlogging channel 'Flying Beast' to another level. He is indeed 'The Renaissance Man'"),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Hans Dalal",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "Tiger Conservationist, Activist",
                style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey.shade500),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                  "A former sound engineer, Hans Dalal has been the foremost voice in field of wildlife and nature conservation in India. Diagnosed with cerebral palsy at the age of 2, Hans Dalal beat all the hurdles his condition posed and made a successful career as a sound engineer, working with renowned artists like Vishal-Shekhar and Trilok Gurtu. His own NGO, PROWL, conducts projects to train forest guards and is also involved in monitoring the movement of tigers."),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
