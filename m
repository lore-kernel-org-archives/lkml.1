Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXDIFOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXDIFOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 01:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXDIFOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 01:14:20 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49270 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbXDIFOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 01:14:19 -0400
Message-Id: <1176095658.16239.1183614988@webmail.messagingengine.com>
X-Sasl-Enc: wx8JEWU/V8lev8ktQl+ulewGC1n5aJc6AmSZPsAOnMOt 1176095658
From: johnrobertbanks@fastmail.fm
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Cc: "Christer Weinigel" <christer@weinigel.se>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <461592FB.5060507@zytor.com>
   <1175819681.20754.1183287946@webmail.messagingengine.com>
   <461596DE.2020802@zytor.com>
   <1175823288.25662.1183293506@webmail.messagingengine.com>
   <4615C780.5040407@zytor.com>
   <1175833931.8916.1183307802@webmail.messagingengine.com>
   <20070407191715.GG3510@csclub.uwaterloo.ca>
   <1175993097.32498.1183512070@webmail.messagingengine.com>
   <m3zm5jebad.fsf@zoo.weinigel.se>
   <1176069053.31062.1183584012@webmail.messagingengine.com>
   <461973AD.5060906@student.ltu.se>
Subject: Re: Reiser4. BEST FILESYSTEM EVER - Christer Weinigel
In-Reply-To: <461973AD.5060906@student.ltu.se>
Date: Sun, 08 Apr 2007 22:14:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2007 00:58:53 +0200, "Richard Knutsson"
<ricknu-0@student.ltu.se> said:
> Wow, I'm impressed. Think you got the record on how many mails you 
> referenced to in a reply... 

TWO actually. I guess you are easily impressed.

A simple cut and paste error.

> You have got some rude answers and you have called them back on it 

Yeah, I (fairly closely) mimicked their behavior to make a point.

> + you have repeated the same statement several times, that is 
> not the best way of convincing people.

I know you DON'T believe that, as you are about the tenth person to
repeat that "repeating stuff has no effect."

> I believe you picked up the "anti-Reiser religion"-phrase from previous 
> rant-wars (otherwise, why does that "religion"-phrase always come up, 
> and (almost) only when dealing with Reiser-fs), and yes, there has been 
> some clashes caused by both sides, so please be careful when dealing 
> with this matter.

NO. You people simply come across as zealots who work together, against
Reiser4.

Hence the term "anti-Reiser religion."

> Would you be willing to benchmark Reiser4 with some compressed 
> binary-blob and show the time as well as the CPU-usage? 

I might be. I don't really know how to set it all up.

Perhaps if you guided me through it.

> >
> > You deliberately ignored the fact that bad blocks are NOT dealt with by
> > the filesystem,... but by the operating system. Like I said: If your
> > filesystem is writing to bad blocks, then throw away your operating
> > system.
> >   

> I may have missed something, but if my room-mate took my harddrive, 
> screwed it open, wrote a love-letter on the disk with a pencil and then 
> returned it (ok, there may be some more plausible reasons for 
> corruption), is the OS really suppose to handle it? 

Yeah, I can't see how the OS could read the love-letter either.

But one thing is for sure. The FS ain't responsible for reading it.

> Yes, it should not 
> assign any new data to those blocks but should it not also fall into the 
> file-systems domain to be able to restore some/all data?

It's a tough ask of any FS. 

Microsoft's filesystem checker totally roasted all my data on an XP-box
last night. 

I had used ntfsresize to reduce the partition size and had a power
outage. 

Later, Windows booted, ran the filesystem checker, seemed OK. 

Next time I boot, all I get is Input/Output error.

> 
> Just my 2c to the pond
> Richard Knutsson
> 
Addin my 2c
John.
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

