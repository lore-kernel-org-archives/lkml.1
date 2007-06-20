Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbXFTTGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbXFTTGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbXFTTGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:06:36 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:35876
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452AbXFTTGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:06:35 -0400
Date: Wed, 20 Jun 2007 12:06:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Michael Poole <mdpoole@troilus.org>, Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <467977F7.2040506@zytor.com>
Message-ID: <Pine.LNX.4.64.0706201200550.30395@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
 <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
 <ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
 <or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
 <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
 <9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
 <2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
 <871wg6trnx.fsf@graviton.dyn.troilus.org> <467977F7.2040506@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, H. Peter Anvin wrote:

> Michael Poole wrote:
>> Tomas Neme writes:
>>
>>> I have been following this discussion for the last week or so, and
>>> what I haven't been able to figure out is what the hell is the big
>>> deal with TiVO doing whatever they want to with their stupid design.
>>> They made a design, they build a machine, they sell it as is, and
>>> provide source code for GPL'ed software... what's your problem?
>>
>> It's simple: they don't provide _complete_ source code.  They keep the
>> source code for the part of their Linux kernel images that provides
>> the functionality "runs on Tivo DVRs".  The GPL requires that
>> distributors of binary versions provide complete source code, not just
>> the parts of source code that are convenient.
>>
>
> If true, that's a clear violation of the GPLv2, but it's very different
> from preventing the loading of modified images on their hardware (which
> appears to be permitted by v2.)
>
> 	-hpa

this is very much NOT true. if you take the source the provide you can 
compile a kernel that will run on the tivo, the only thing you have to do 
(on some models) is to change the bios to skip the step that checks if the 
kernel has been tampered with.

in fact, people have ported the nessary changes all the way up to the 2.6 
kernels (the tivos run a 2.1 derived kernel). you can buy hard drives to 
plug into your tivo with newer kernels (and yes, you do get source from 
those folks as well)

by the way, the first hacks that disabled these checks were done by people 
who were interested in getting their tivo to boot faster (they found an 
expensive bios routing that wasn't nessasary to boot), they weren't 
interested in loading different software on the box. when they released 
the hack other people realized that they had opened the door for other 
changes.

David Lang
