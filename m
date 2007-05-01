Return-Path: <linux-kernel-owner+w=401wt.eu-S1423664AbXEAV3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423664AbXEAV3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423663AbXEAV3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:29:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:49516 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1423664AbXEAV3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:29:39 -0400
Cc: mrechberger@gmail.com, mchehab@infradead.org, linux-dvb@linuxtv.org,
       xyzzy@speakeasy.org, abraham.manu@gmail.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 01 May 2007 23:29:37 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <4637A4A0.3080909@simon.arlott.org.uk>
Message-ID: <20070501212937.300960@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<1178031333.3958.63.camel@localhost> <20070501164054.26090@gmx.net>
 <20070501183048.268140@gmx.net> <46378BFE.1060009@simon.arlott.org.uk>
 <20070501193442.272400@gmx.net> <4637A4A0.3080909@simon.arlott.org.uk>
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (.. was: Critical
 points about ...)
To: Simon Arlott <simon@fire.lp0.eu>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19N2+lv1DZNP7nmJp7lLmVbn3TC15HYOk148XDSgM
 HKVxpoX5xkEnul2rlFkgd4XV0+L/CPAN9XVQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: eYYCcuUyTiE+VXfvGGRwpsd9ZUVSRFei
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Tue, 01 May 2007 21:35:44 +0100
Von: Simon Arlott <simon@fire.lp0.eu>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-kernel@vger.kernel.org, abraham.manu@gmail.com, xyzzy@speakeasy.org, linux-dvb@linuxtv.org, mchehab@infradead.org, mrechberger@gmail.com
Betreff: Re: [linux-dvb] Re: DST/BT878 module customization (.. was: Critical points about ...)

> On 01/05/07 20:34, Uwe Bugla wrote:
> > -------- Original-Nachricht --------
> > Datum: Tue, 01 May 2007 19:50:38 +0100
> > Von: Simon Arlott <simon@fire.lp0.eu>
> >> On 01/05/07 19:30, Uwe Bugla wrote:
> >>> <fewer rude comments than usual>
> >> If you would avoid making inflammatory comments, the people who are
> trying
> >> to 
> >> help you will be more inclined to fix the problems that these patches
> DO
> >> cause 
> >> so they can be added.
> >>
> >> A while ago, you went on and on about your broken floppy drive and how
> >> people 
> >> shouldn't do things that break other systems - even if they have no
> idea
> >> that 
> >> was happening - yet here you are now demanding people do the same
> thing.
> > 
> > WRONG!
> > I offered a patch for the broken floppy, but Linus was faster and ripped
> the whole section out, so do not even try to misunderstand or quote me out
> of context!
> 
> You complained that changes which break your system[1] shouldn't be added 
> and now rudely demand your desired changes which have been shown to break 
> others' should be added immediately. I don't believe I misunderstood you 
> or got the wrong context - it has nothing to do with the related patch.
> 
> [1] http://lkml.org/lkml/2007/2/25/127
> 
> 
> > So I say it again:
> > The theses Mr. Chehab invents NOT TO DO SOMETHING do never carry fully
> transparent information with them. It's just air bubbles that he is
> producing, nothing else!
> > It's always and ever the other part that is exposed to offer transparent
> info, but never Chehab himself!
> > And it's exactly the same thing with Abraham or Krufky!
> > 
> > And does that behaviour conform with democratic terms? NO WAY!
> > So there are three mismatches around: Their names are: Abraham, Krufky,
> and Chehab!
> 
> You're worse than that reiser4 fanatic, at least he wasn't rude when he 
> repeated himself over and over and over. I was going to offer to help 
> you bisect between -git1 and -git2 (it'd be trivial to run the bisect 
> here and provide patches to test)

Well, thank you for that offer in mind, but the git bisect is only necessary for some people needing to know what the reasons for the AMD K7 router Oopses are (speak: what needs to be inserted in vanilla mainline to make it "round" (2.6.21.3, 4, 5,.....)).

But meanwhile I got three perfect running machines, implying 
Trent's stuff, implying self-built stuff, and everything built up on 2.6.21-git4), so I can solve my problems on my own.
See, if it is almost impossible to build up necessary majorities to get rid of some utmost nasty gatekeepers @linuxtv.org then I can keep my own patch repositories and save lots of energy.
Why should I fight against windmills of such an enourmous stupidity like diagnosed around here? No reason for that!
Why should I take part in testing the mm-tree?
Nothing but waste of time, isn't it??

The technical issues that still need to be fixed plus some creative ideas I sent to mrechberger@gmail.com plus to Trent Piepho. If they get this done - excellent!
If not - why should I waste nerves?
Because of some stupid Abraham or Krufky??
Or the intransparence of Mr. Chehab's air bubbles??
Why should I??
 
snip
_____________________________________________

Uwe

(Rest blather cut off)

> Simon Arlott

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
