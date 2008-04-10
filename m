Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYDJNTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYDJNTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYDJNTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:19:05 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:19646 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbYDJNTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UmWOGz3u9Gb/ymZmA2rclCCPbCsNfiQ5c9u1vT0VdEfiEbIursIuWoPM24uGVITr0dMsCdvpHs2bk/5tGA2ilbwOTgEeOHHzZricc/h0x93IpG2TTUyYA2V8TcqCV2/3C8AyjqnsxpPpwGpDyDFCJMn8a9KDnDV6CHoEBcK8hkU=
Message-ID: <5699f8f00804100619h3319fbdcy8adc60b45e2e7eec@mail.gmail.com>
Date: Thu, 10 Apr 2008 15:19:01 +0200
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
Subject: Re: Starting point: Suspend to RAM on embedded devices?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E301E96266@zuerich.BC-Int.NET>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83116F0A4FF67A4F97BA0B6E408C48E301E96208@zuerich.BC-Int.NET>
	 <5699f8f00804100123q2a9d278arf9b076c91efbbd56@mail.gmail.com>
	 <83116F0A4FF67A4F97BA0B6E408C48E301E96234@zuerich.BC-Int.NET>
	 <5699f8f00804100351q427b1a0dxdeb8254b370cb8ed@mail.gmail.com>
	 <83116F0A4FF67A4F97BA0B6E408C48E301E96266@zuerich.BC-Int.NET>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 3:04 PM, Wappler Marcel
<Marcel.Wappler@bridgeco.net> wrote:
> Wander Winkelhorst wrote:
>  > Well, my tomtom one V2 takes a couple (5-10) of seconds to wake up
>  > again. but that time includes reinitialising the bluetooth chip,
>  > checking the SD card, restarting the GPS, loading AGPS data and
>  > resuming the navigation software. If you don't have to do all those
>  > things it would probably resume a lot faster.
>
>  So Wander,
>
>  I had a short look in to the opentom.org project and have got a lot of new questions:

I can't anwser all of these questions, I'm not a part of the opentom
project. If you want to ask more questions to the people who are,
plase ask on the opentom mailing list.

>  - does the opentom.org kernel support the original "suspend to RAM" functionality of TomToms kernel?
I don't know, but IMHO it doesn't matter, because you can just use the
TomTom kernel.

>  - is there anybody using this functionality?
The Opentom project is a bit... quiet...

>  - has somebody measured the power consuption in the sleep mode?
With the TomTom provided kernels, the power consumption is next to
nothing. These devices are powered by a small battery, yet can stay
suspended for weeks.

>  - the opentom kernel has a file "/arch/arm/kernel/apm.c" which is not in the normal Linux kernels. Where comes this file and other
>  power saving infrastructure from, where can I grab it, is there anyone else out there using it, on which device?
I don't know, sorry.

Wander.
