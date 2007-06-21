Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbXFUGGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbXFUGGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXFUGGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:06:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbXFUGGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:06:23 -0400
To: david@lang.hm
Cc: Michael Poole <mdpoole@troilus.org>, Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
	<2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
	<871wg6trnx.fsf@graviton.dyn.troilus.org>
	<2e6659dd0706201205i52e0b836oe642e2b442e425d7@mail.gmail.com>
	<87wsxysaad.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201232290.30395@asgard.lang.hm>
	<87odjas9f7.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201241060.30395@asgard.lang.hm>
	<ortzt2rmuk.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706202106040.31603@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 03:05:56 -0300
In-Reply-To: <Pine.LNX.4.64.0706202106040.31603@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 21\:08\:23 -0700 \(PDT\)")
Message-ID: <orir9hrge3.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, david@lang.hm wrote:

> On Thu, 21 Jun 2007, Alexandre Oliva wrote:
>> On Jun 20, 2007, david@lang.hm wrote:
>> 
>>> but the signature isn't part of the kernel, and the code that checks
>>> the signature is completely independant.
>> 
>> Well, then remove or otherwise mangle the signature in the disk of
>> your TiVo DVR and see at what point the boot-up process halts.

> I have actually done exactly that. what happens is that the bootloader
> detects a problem and switches to the other active partition ane
> reboots. ir neither of the boot partitions meet the requirements the
> cycle will continue forever.

Oh, too bad.  That must be a bug in the boot loader, right? :-)


BTW, since you got a TiVo...  I'm writing an article on Tivoization,
could you (or anyone else) please help me get information as to what
other GPLed programs or libraries TiVo includes in their devices?

Thanks in advance,

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
