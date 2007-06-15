Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbXFOTtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbXFOTtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXFOTtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:49:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:58445 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbXFOTti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=HwTb/53O4HQvQgpuTJYBNhf7Xdhia6+nKZTn8FqFbtkL74lok0QN+1bylObNvGGql7jIARm0R9oqnJ3fc82CPhPdCWYOHVsuzrE7xd6OcG6e2MlCiS3WhW3GUApDlLw9QvpJw//qf2z0JXnQpCN3w1KJMRP4iFnm0F3nfKbe244=
Date: Fri, 15 Jun 2007 21:48:11 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-Id: <20070615214811.ba498cd0.diegocg@gmail.com>
In-Reply-To: <orodjib9b6.fsf@oliva.athome.lsd.ic.unicamp.br>
References: <466A3EC6.6030706@netone.net.tr>
	<200706132140.13490.dhazelton@enter.net>
	<20070614020827.GO3588@stusta.de>
	<200706132243.14651.dhazelton@enter.net>
	<20070614025640.GQ3588@stusta.de>
	<9578.1181793617@turing-police.cc.vt.edu>
	<20070614152034.GS3588@stusta.de>
	<alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
	<orwsy6e89s.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614204725.cdf790a7.diegocg@gmail.com>
	<alpine.LFD.0.98.0706141204330.14121@woody.linux-foundation.org>
	<orodjib9b6.fsf@oliva.athome.lsd.ic.unicamp.br>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 14 Jun 2007 16:55:09 -0300, Alexandre Oliva <aoliva@redhat.com> escribió:

> > On Thu, 14 Jun 2007, Diego Calleja wrote:
> 
> >> And the FSF is trying to control the design and licensing of
> >> hardware throught the influence of their software.
> 
> It's not.  It's only working to ensure recipients of the Free Software
> can modify and share the software.

Those may be the intentions, but I claim that your statement is false. The
anti-tivoisation FSF movement is not "working to ensure recipients of the
Free Software can modify and share the software". 

They can't, because the fact is that hardware vendors can NOT stop you
from "modifing and sharing the software". They only can stop you from
running your modifications, which is very different. So this is a 
_hardware_ limitation. It's pointless to try to address this problem
with software licenses.

What the anti-tivoisation movement is trying to do: "If you are a vendor
of tivoized hardware you must give your users whatever information is
needed to run modifications of their software"

How it works in the real world: "You can't run this software in hardware
that doesn't allow to run code modifications of this software"

So while the anti-tivoisation movement is trying to limit hardware
design/licensing, the fact is that what you are restricting is not the
hardware, but the _software_, in a way very different from the 'restrictions'
that the GPL has when compared with the BSD ie: in a way that doesn't
benefit freedom or contribution of code. Because your users already
can modify and share their code regardless of what hardware they're
using (even if they can't run their modifications), you're just adding
pointless prohibitions.
