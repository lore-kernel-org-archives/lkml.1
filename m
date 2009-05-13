Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbZEMWIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbZEMWIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZEMWIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:08:11 -0400
Received: from mail1001.centrum.cz ([90.183.38.131]:44419 "EHLO
	mail1001.centrum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbZEMWIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:08:11 -0400
Date: Thu, 14 May 2009 00:07:58 +0200
From: <trekker.dk@centrum.cz>
To: <pavel@ucw.cz>
Cc: <tuxonice-devel@lists.tuxonice.net>, <linux-pm@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-Mailer: Centrum Mail 5.0
MIME-Version: 1.0
X-Priority: 3
Message-ID: <200905140007.4324@centrum.cz>
References: <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz> <20090510053840.GG1363@ucw.cz> <200905112319.8749@centrum.cz> <20090511212350.GA3397@elf.ucw.cz> <200905132219.19216@centrum.cz> <20090513202429.GA3680@elf.ucw.cz>
In-Reply-To: <20090513202429.GA3680@elf.ucw.cz>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> >> >Which kernels you tried, what hw it is? Can you do s2ram?
>> >> 
>> >> Regarding hardware - 
>> >> 
>> >> 1. AMD Athlon 1700+, VIA KT333 chipset based MB, nVidia GeForce 2
>> >> 2. AMD X2 Athlon, AMD690V chipset based MB, nVidia 7600GT
>> >> 3. (current) AMD X4 Phenom II,  AMD780G chipset and nVidia 9600GT 
>> >> (binary driver for video card every time)
>> >
>> >Ok, binary drivers may be a problem. Will it work without that? Should
>> >be easy to test with init=/bin/bash.
>> 
>> Yes, that works - and after complete boot w/o loading binary driver resume works too.
>> 
>
>Cool. I'm afraid you have to ask nvidia for help here. (Or maybe you
>can just unload nvidia.ko before suspend/reload it after
>resume). Anyway problem is with nvidia here..

And that's where we get to the advantage of TOI again: with TOI I don't have to do that, 
suspend works with X.org running. (IMO there's no point in suspending if I have 
to start all X apps again)

Anyway, I think this thread is a bit off-topic in -devel list, so if there isn't anything 
important to add, this will be the last post from me.

Regards 
JB


