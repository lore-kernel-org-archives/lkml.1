Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbXKXTFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbXKXTFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 14:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbXKXTFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 14:05:46 -0500
Received: from m-04.th.seeweb.it ([217.64.195.227]:42283 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXKXTFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 14:05:46 -0500
Message-ID: <474876BE.90201@users.sourceforge.net>
Date: Sat, 24 Nov 2007 20:08:46 +0100
From: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071122)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Len Brown <lenb@kernel.org>
Subject: Re: Laptop keyboard unusable when ACPI is active
References: <47001841.1000107@users.sourceforge.net> <470F600B.3030305@users.sourceforge.net> <47452EAC.5060801@users.sourceforge.net> <200711232321.44048.lenb@kernel.org>
In-Reply-To: <200711232321.44048.lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown ha scritto:
> On Thursday 22 November 2007 02:24, legolas558@users.sourceforge.net wrote:
>> It is also important to note that this bug always comes with bug 8740 
>> http://bugzilla.kernel.org/show_bug.cgi?id=8740 (also confirmed and also 
>> an ACPI issue).
>>     
> No, 8740 is not an ACPI issue.
> http://bugzilla.kernel.org/show_bug.cgi?id=8740#c2
>   
Sorry for the misleading statement; I no more think that it is an ACPI 
issue.
Although I am still curious about the reason of these bugs happening 
together even on different hardware configurations; maybe a side effect 
of the same kernel bug? No idea.

Best regards,
--
  Daniele C.

> -Len
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

