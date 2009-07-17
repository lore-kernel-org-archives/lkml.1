Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZGQXU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZGQXU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 19:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZGQXUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 19:20:55 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:56748 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZGQXUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 19:20:54 -0400
MIME-Version: 1.0
X-Originating-IP: [97.115.190.43]
In-Reply-To: <4A604246.5060204@gmail.com>
References: <9f53b4330907161718ydbac090k2afc7a749fc9f6f2@mail.gmail.com>
	 <4A604246.5060204@gmail.com>
Date: Fri, 17 Jul 2009 16:20:51 -0700
Message-ID: <9f53b4330907171620u5fd71e69t862f582a05251f0@mail.gmail.com>
Subject: Re: SDIO Stack and Device Support
From: Robert Emanuele <rob@emanuele.us>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This support for these wireless chips in the mainline kernel is great.
 Originally I was looking at wireless SDIO cards from Spectec and
Silex.  What manufacturers use the libertas/Marvell chipsets in SDIO
Cards?  (or are they only available as modules?)

Thank you,

Rob

On Fri, Jul 17, 2009 at 2:20 AM, Jonathan
Cameron<Jonathan.Cameron@gmail.com> wrote:
> Robert Emanuele wrote:
>> Greetings all,
>>
>> I'm trying to find out more information about the status of an SDIO
>> stack and SDIO devices in the kernel.  I see under drivers/mmc/ some
>> SDIO support.
>>
>> I'm evaluating the potential of getting a Wireless SDIO card to work
>> with the 2.6 kernel.  So far all I see in the kernel is support for an
>> SDIO UART.  There is a patch on sourceforge for an SDIO stack and
>> drivers from Atheros but that is for 2.6.18.  Is there current support
>> for other SDIO wireless devices in the kernel?
>>
> There is pretty good support for the Marvell chips (sd8686 etc) in the
> mainline
> kernel. Take a look under drivers/net/wireless/libertas/
>
> I've also copied in the linux-wireless list.
>
>
>
>
>
>
