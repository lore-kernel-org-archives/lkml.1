Return-Path: <linux-kernel-owner+w=401wt.eu-S1761259AbXFJRe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbXFJRe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXFJReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:34:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbXFJReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:34:18 -0400
Date: Sun, 10 Jun 2007 10:33:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tarkan Erimer <tarkan@netone.net.tr>
cc: debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706101029300.20321@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>  <18026.16739.228277.938421@notabene.brown>
  <20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr> 
 <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>  <466BCBBC.90305@netone.net.tr>
  <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
 <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
 <466C0901.4000405@netone.net.tr>
 <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Jun 2007, Linus Torvalds wrote:
>
> I have yet to see any actual *reasons* for licensing under the GPLv3, 
> though.

Btw, if Sun really _is_ going to release OpenSolaris under GPLv3, that 
_may_ be a good reason. I don't think the GPLv3 is as good a license as 
v2, but on the other hand, I'm pragmatic, and if we can avoid having two 
kernels with two different licenses and the friction that causes, I at 
least see the _reason_ for GPLv3. As it is, I don't really see a reason at 
all.

I personally doubt it will happen, but hey, I didn't really expect them to 
open-source Java either(*), so it's not like I'm infallible in my 
predictions.

				Linus

(*) And I've been pushing for that since before they even released it - I 
walked out on Bill Joy at a private event where they discussed their 
horrible previous Java license.
