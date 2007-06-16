Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbXFPKTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbXFPKTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXFPKTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:19:06 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:38504 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbXFPKTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:19:04 -0400
Message-ID: <4673B913.2020506@dgreaves.com>
Date: Sat, 16 Jun 2007 11:18:59 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Michael Gerdau <mgd@technosis.de>, Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>	<200706142049.41819.dhazelton@enter.net>	<200706150825.15491.mgd@technosis.de>	<200706150520.15086.dhazelton@enter.net>	<46726793.1020206@dgreaves.com>	<alpine.LFD.0.98.0706151004460.14121@woody.linux-foundation.org>	<4672D648.7020700@dgreaves.com> <m37iq496z9.fsf@maximus.localdomain>	<46738CD2.2080804@dgreaves.com> <m3r6ocuy4d.fsf@maximus.localdomain>
In-Reply-To: <m3r6ocuy4d.fsf@maximus.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> David Greaves <david@dgreaves.com> writes:
> 
>>> How hard would it be to reprogramm the flash?
>> The flash contains hashes signed by the companies private key.
>>
>> The kernel contains the public key. It can decrypt the hashes but the
>> private key isn't available to encrypt them. So although you can put a
>> new application onto the system, you can't create a signed hash to
>> write to the flash.
 >
> Then how hard would it be to reprogram the flash, to get rid of all
> this crap? Or to just put your public key there.
> 
> Do they at least use BGA type of flash chips so you can't attach
> a clip and have to use something more demanding?

Stop trying to technically crack my 5-minute fag-packet design - that's easy and 
boring :)

Tivo have solved this problem - use their solution - but do it on something more 
general purpose.

Help fix it - the point is more "is this feasible". And if it is, "does it matter?"


David


