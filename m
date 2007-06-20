Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbXFTVSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbXFTVSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXFTVSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:18:23 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39991
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbXFTVSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:18:22 -0400
Date: Wed, 20 Jun 2007 14:16:57 -0700 (PDT)
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
In-Reply-To: <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614235004.GA14952@elte.hu>
 <20070615011012.6c09066e@the-village.bc.nu> <20070615012623.GA25189@elte.hu>
 <20070615101007.0cbfd078@the-village.bc.nu> <orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
 <4673CA7C.5040207@t-online.de> <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070616181902.GB21478@ftp.linux.org.uk> <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <4679557C.5080907@iders.ca>
 <20070620175627.319a6c55@the-village.bc.nu> <46797C52.4020907@iders.ca>
 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Alexandre Oliva wrote:

> Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
> 
> On Jun 20, 2007, Andrew McKay <amckay@iders.ca> wrote:
>
>> However, I don't see how this would ever require a company like Tivo
>> or Mastercard to have their networks play nice with a unit that has
>> been modified by the end user, potentially opening up some serious
>> security holes.
>
> Which is why the GPLv3 doesn't make the requirement that you stated.

so if the BIOS checked the checksum of the boot image and if it found it 
wasn't correct would disable the video input hardware but let you boot the 
system otherwise it would be acceptable to you and the GPLv3?

somehow I doubt it, but that's what it would take to prevent modified 
software from interacting with their networks (remembering that these 
networks are the cable and satellite networks in some cases)

it also seems that if this was the case it would be a trivial work-around 
for the GPLv3 if it was acceptable.

David Lang
