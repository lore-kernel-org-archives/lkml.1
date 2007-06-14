Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXFNXyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXFNXyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXFNXxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:53:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43112 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751635AbXFNXxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:53:53 -0400
Date: Fri, 15 Jun 2007 00:56:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Nottingham <notting@redhat.com>
Cc: Alexandre Oliva <aoliva@redhat.com>, Florin Malita <fmalita@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615005659.443fdbf5@the-village.bc.nu>
In-Reply-To: <20070614234507.GA3860@nostromo.devel.redhat.com>
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140305.50095.dhazelton@enter.net>
	<orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
	<46717C58.8050501@gmail.com>
	<ord4zye6iv.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4671A528.5040300@gmail.com>
	<or1wge9pwr.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614234507.GA3860@nostromo.devel.redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 19:45:08 -0400
Bill Nottingham <notting@redhat.com> wrote:

> Alexandre Oliva (aoliva@redhat.com) said: 
> > And since the specific implementation involves creating a derived work
> > of the GPLed kernel (the signature, or the signed image, or what have
> > you)
> 
> Wait, a signed filesystem image that happens to contain GPL code
> is now a derived work? Under what sort of interpretation does *that*
> occur?
> 
> (This pretty much throws the 'aggregation' premise in GPLv2 completely
> out.)

Perhaps the FSF will in future remember to pack a copy of the GPL in each
of its md5sum files on the mirror if this is a derivative work, and
modify the bittorrent protocol to include a copy of the GPL in the seed
files 8)

Alan
