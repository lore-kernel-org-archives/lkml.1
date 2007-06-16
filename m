Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbXFPOCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbXFPOCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 10:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbXFPOCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 10:02:45 -0400
Received: from mraos.ra.phy.cam.ac.uk ([131.111.48.8]:58021 "EHLO
	mraos.ra.phy.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbXFPOCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 10:02:44 -0400
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Carlo Wood <carlo@alinoe.com>, Alexandre Oliva <aoliva@redhat.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, Sean <seanlkml@sympatico.ca>,
       Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3 
In-Reply-To: Your message of "Sat, 16 Jun 2007 10:57:38 +0200."
             <m3myz0uvi5.fsf@maximus.localdomain> 
Date: Sat, 16 Jun 2007 15:01:58 +0100
From: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>
Message-Id: <E1HzYqk-0001aI-00@skye.ra.phy.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:
> > So, by making the COPYING contain the v2 text, is the author
> > specifying a particular version?  If yes, then the sec. 9 provision
> > would be meaningless, since there would be no way to not specify a
> > version number.
> 
> Of course the "published under terms of GPL." would do.

It would do, if you could stop there and say no more.  But:

  You may copy and distribute verbatim copies of the Program's source
  code as you receive it, in any medium, provided that you...give any
  other recipients of the Program a copy of this License along with the
  Program.  [GPLv2, section 1]

So you have to give recipients the license text from a particular
version of the GPL.  To make that the only version unde which the work
is licensed, you have to add something like "Licensed under the
GPLv2".  Otherwise sec. 9 says that you offer the work under any
version of the GPL, and the licensee can take his or her pick -- even
using v1 (!).

-Sanjoy
