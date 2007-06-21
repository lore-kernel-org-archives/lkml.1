Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXFUFbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXFUFbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 01:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXFUFb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 01:31:27 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:42067
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXFUFb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 01:31:26 -0400
Date: Wed, 20 Jun 2007 22:30:35 -0700 (PDT)
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
In-Reply-To: <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <20070615012623.GA25189@elte.hu> <20070615101007.0cbfd078@the-village.bc.nu>
 <orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br> <4673CA7C.5040207@t-online.de>
 <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616181902.GB21478@ftp.linux.org.uk>
 <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <4679557C.5080907@iders.ca>
 <20070620175627.319a6c55@the-village.bc.nu> <46797C52.4020907@iders.ca>
 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br> <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
 <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Alexandre Oliva wrote:

> On Jun 20, 2007, david@lang.hm wrote:
>
>> On Wed, 20 Jun 2007, Alexandre Oliva wrote:
>>> Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
>>>
>>> On Jun 20, 2007, Andrew McKay <amckay@iders.ca> wrote:
>>>
>>>> However, I don't see how this would ever require a company like Tivo
>>>> or Mastercard to have their networks play nice with a unit that has
>>>> been modified by the end user, potentially opening up some serious
>>>> security holes.
>>>
>>> Which is why the GPLv3 doesn't make the requirement that you stated.
>
>> so if the BIOS checked the checksum of the boot image and if it found
>> it wasn't correct would disable the video input hardware but let you
>> boot the system otherwise it would be acceptable to you and the GPLv3?
>
> I don't think so, but IANAL.  What do you think?  Here's what I
> think to be the relevant passages.
>
>  [...] The information must suffice to ensure that the continued
>  functioning of the modified object code is in no case prevented or
>  interfered with solely because modification has been made.
>
>  [...]
>
>  The requirement to provide Installation Information does not include
>  a requirement to continue to provide support service, warranty, or
>  updates for a work that has been modified or installed by the
>  recipient, or for the User Product in which it has been modified or
>  installed.  Network access may be denied when the modification
>  itself materially and adversely affects the operation of the network
>  or violates the rules and protocols for communication across the
>  network.

Ok, so if refusing to run software that's tampered with isn't acceptable, 
and disabling the hardware that would be needed to talk on the network 
isn't acceptable. how exactly can they prevent a system that's been 
tampered with from accessing their network? (something even you say they 
have a right to do)

asking a device that's running software that you haven't verified to give 
you a checksum of itself isn't going to work becouse the software can just 
lie to you.

you claim they have this right, but then claim to prohibit every possible 
method of them excercising that right.

pick one side or the other, you don't get both.

David Lang
