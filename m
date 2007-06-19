Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbXFSVrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbXFSVrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXFSVrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:47:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbXFSVrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:47:03 -0400
To: david@lang.hm
Cc: Daniel Drake <dsd@gentoo.org>, Bron Gondwana <brong@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>
	<orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615072322.GA7594@brong.net>
	<orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616021630.GA30660@brong.net>
	<orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616103130.GD32405@brong.net>
	<orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616233251.GA17270@brong.net>
	<ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
	<46774BD3.6010605@gentoo.org>
	<ory7ig4h24.fsf@oliva.athome.lsd.ic.unicamp.br>
	<Pine.LNX.4.64.0706191404060.26701@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 18:46:16 -0300
In-Reply-To: <Pine.LNX.4.64.0706191404060.26701@asgard.lang.hm> (david@lang.hm's message of "Tue\, 19 Jun 2007 14\:07\:18 -0700 \(PDT\)")
Message-ID: <orr6o7zkgn.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, david@lang.hm wrote:

> On Tue, 19 Jun 2007, Alexandre Oliva wrote:
>> On Jun 19, 2007, Daniel Drake <dsd@gentoo.org> wrote:
>> 
>>> I realise that the latest GPLv3 draft would not pose restrictions
>>> here, as such devices would not be classified as consumer
>>> products.
>> 
>> And even if they were, there's always ROM.
>> 
>> I don't know whether hardware seals that state "once you break this
>> seal, law prohibits the use of this device with human patients".

> once you break the seal the device is no longer certified. an
> uncertified device cannot be used.

Yup.  That's the law.

At which point it's not the hardware vendor imposing the restriction,
so this use is perfectly acceptable.


One could presumably implement similar seals in software.  Nothing
wrong with a signature used to indicate that the device has been
tampered with.  Even a led somewhere that reflects this status.

None of this prevents the user from enjoying the freedoms he's
entitled to, according to the laws of the place where he lives.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
