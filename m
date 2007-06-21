Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbXFUHeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbXFUHeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 03:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXFUHd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 03:33:57 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34661
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXFUHd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 03:33:56 -0400
Date: Thu, 21 Jun 2007 00:33:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alexandre Oliva <aoliva@redhat.com>
cc: Andrew McKay <amckay@iders.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <ory7idpykk.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706210031280.31603@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070616181902.GB21478@ftp.linux.org.uk> <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <4679557C.5080907@iders.ca>
 <20070620175627.319a6c55@the-village.bc.nu> <46797C52.4020907@iders.ca>
 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
 <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
 <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
 <ory7idpykk.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Alexandre Oliva wrote:

> On Jun 21, 2007, david@lang.hm wrote:
>
>> no, one of the rules for the network is that the software must be
>> certified,
>
> In this case you might have grounds to enforce this restriction of the
> network on the network controller itself, I suppose.

how would the network controller know if the software has been modified?

> Not that you should disable the network controller entirely (this
> would render the computer useless for many other purpose unrelated
> with blocking connections to your network).
>
> You could instead arrange for the network controller to send some
> signal that enables the network to recognize that the device is
> running certified software.

what sort of signal can the network controller send that couldn't be 
forged by the OS?

how would you do this where the device is a receiver on the netwoek (such 
as a satellite receiver)

David Lang
