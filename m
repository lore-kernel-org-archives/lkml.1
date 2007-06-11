Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbXFKKvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbXFKKvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 06:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbXFKKve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 06:51:34 -0400
Received: from bay0-omc1-s36.bay0.hotmail.com ([65.54.246.108]:19524 "EHLO
	bay0-omc1-s36.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755716AbXFKKvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 06:51:33 -0400
Message-ID: <BAY128-F371814D6A3033FD7855953BC1A0@phx.gbl>
X-Originating-IP: [80.200.248.200]
X-Originating-Email: [ghpille@hotmail.com]
In-Reply-To: <466C3C98.8060800@shaw.ca>
From: "Gerard H. Pille" <ghpille@hotmail.com>
To: hancockr@shaw.ca, mikpe@it.uu.se
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: system clock slow on Athlon AMD64 since 2.6.21
Date: Mon, 11 Jun 2007 12:51:30 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 11 Jun 2007 10:51:32.0914 (UTC) FILETIME=[79630920:01C7AC16]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




>From: Robert Hancock <hancockr@shaw.ca>
>To: Mikael Pettersson <mikpe@it.uu.se>
>CC: ghpille@hotmail.com, linux-kernel@vger.kernel.org
>Subject: Re: PROBLEM: system clock slow on Athlon AMD64 since 2.6.21
>Date: Sun, 10 Jun 2007 12:02:00 -0600
>
>Mikael Pettersson wrote:
>>On Fri, 08 Jun 2007 10:14:03 +0200, Gerard H. Pille wrote:
>>>[1.] One line summary of the problem:
>>>Since I switched from 2.6.20 to 2.6.21 on my Athlon AMD64 laptop, the 
>>>system time is slow - about 1' on 15'.
>>
>>According to your system description it seems that you have a
>>Targa Visionary laptop with a VIA chipset and a Mobile Athlon64.
>>If so, then you probably have the same problem I reported some time
>>ago: see <http://marc.info/?l=linux-kernel&m=117681226421346&w=2>
>>and the followup messages. The conclusion was that the chipset's
>>ACPI PM timer slows down when the CPU is in C2.
>>
>>The workaround is to boot with processor.max_cstate=1.
>
>Which, if true, is extremely bizarre, as the whole point and reason for 
>existence of the ACPI PM timer is that it NOT do this, and remain at the 
>same rate regardless of CPU power management changes..
>
>--
>Robert Hancock      Saskatoon, SK, Canada
>To email, remove "nospam" from hancockr@nospamshaw.ca
>Home Page: http://www.roberthancock.com/
>

So I shouldn't have started a new bug report, sorry.  I had once read your  
problem report, but I could not relocate it afterwards.

If I can provide any assistance in debugging, please let me know.

Thanks,

Gerard

_________________________________________________________________
Looking for an old friend? You may find him in  your friends' friends list ! 
http://spaces.live.com/default.aspx?page=Ed01&ss=True

