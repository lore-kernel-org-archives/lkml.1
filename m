Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbXG1U77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbXG1U77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXG1U7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:59:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53327 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXG1U7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:59:51 -0400
Date: Sat, 28 Jul 2007 22:59:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Diego Calleja <diegocg@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Jessup <jonathanjessup@gmail.com>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, lkml@metanurb.dk
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <20070728225148.a0e58fdd.diegocg@gmail.com>
Message-ID: <Pine.LNX.4.64.0707282259220.15125@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <1185588279.1654.1.camel@localhost> <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
 <Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net>
 <954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com>
 <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org>
 <20070728225148.a0e58fdd.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-351318019-1185656390=:15125"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-351318019-1185656390=:15125
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jul 28 2007 22:51, Diego Calleja wrote:
>El Sat, 28 Jul 2007 11:05:25 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> escribió:
>
>> So "modal" things are good for fixing behaviour in the short run. But they 
>> are a total disaster in the long run, and even in the short run they tend 
>> to have problems (simply because there will be cases that straddle the 
>> line, and show some of _both_ issues, and now *neither* mode is the right 
>> one)
>
>I fully agree with this, but plugsched could have avoided this useless "division"
>on the topic of SD vs CFS. IMO that counts as an advantage, too ;)
>

It's like CONFIG_HZ - more or less often debated, and now we have everyone
happy by giving them the choice.




	Jan
-- 
---699020219-351318019-1185656390=:15125--
