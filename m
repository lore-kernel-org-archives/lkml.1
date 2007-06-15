Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXFOTuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXFOTuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXFOTua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:50:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbXFOTu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:50:28 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Florin Malita <fmalita@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr> <4671F127.40000@gmail.com>
	<or8xal6h1f.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706150157.13631.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 16:49:00 -0300
In-Reply-To: <200706150157.13631.dhazelton@enter.net> (Daniel Hazelton's message of "Fri\, 15 Jun 2007 01\:57\:13 -0400")
Message-ID: <orsl8typ5f.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Thursday 14 June 2007 23:19:24 Alexandre Oliva wrote:

>> IANAL, but AFAICT it doesn't.  Still, encoded in the spirit (that
>> refers to free software, bringing in the free software definition), is
>> the notion of protecting users' freedoms, among them the freeom #0, to
>> run the software for any purpose.

> And where in GPLv2 is "Freedom #0"?

It may sound like thin evidence for someone arriving from Venus today,
but the preamble talks about "free software", some passages clearly
imply that software under this license is "free software", the license
is published by the Free Software Foundation, and the Free Software
Foundation has a published definition of Free Software that
establishes the 4 freedoms.

The freedoms defined there resonate very strongly with the
freedoms/rights that the license talks about.  I hope this is enough
evidence to convince you that this is the intent.

The only of the freedoms that's not explicitly mentioned in the
preamble, the freedom to run the software for any purpose, is
mentioned in the legal terms as unrestricted, which is very much in
line with freedom #0, but is outside the scope of a copyright license
because running the program does not require copyright permission.

I'll give you that the preamble doesn't make it clear that the license
is purported to defend freedom #0 too.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
