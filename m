Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbXFOAgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbXFOAgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXFOAgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:36:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465AbXFOAgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:36:11 -0400
Date: Thu, 14 Jun 2007 17:34:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070615000232.GB9463@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706141731120.14121@woody.linux-foundation.org>
References: <20070614025640.GQ3588@stusta.de> <9578.1181793617@turing-police.cc.vt.edu>
 <20070614152034.GS3588@stusta.de> <alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
 <orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141100390.14121@woody.linux-foundation.org>
 <ork5u6cpc2.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706141304210.14121@woody.linux-foundation.org>
 <20070614231812.GA9463@alinoe.com> <20070615003919.1abfb155@the-village.bc.nu>
 <20070615000232.GB9463@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Carlo Wood wrote:
> 
> But then the paragraph from COPYING kicks in, reading:

Read the COPYING file more closely, and realize that "the Program" has 
always specified a version number of this license.

It used to include it just by virtue of having the COPYING file *itself* 
be included (and that's v2), but since some people felt that was unclear, 
the COPYING file has this language pretty visibly at the top:

 Also note that the only valid version of the GPL as far as the kernel
 is concerned is _this_ particular version of the license (ie v2, not
 v2.2 or v3.x or whatever), unless explicitly otherwise stated.

> Any, 'any version' probably includes version 3 as well.

Not for the kernel. Exactly because the kernel _does_ specify the version. 
So the sequence you quoted is a non-issue.

In other words: any file that does not *explicitly* say that it's "v2 or 
later" is v2 only.

		Linus
