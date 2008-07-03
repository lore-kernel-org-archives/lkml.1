Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYGCOTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYGCOTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbYGCOT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:19:29 -0400
Received: from mail.atmel.fr ([81.80.104.162]:57417 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158AbYGCOT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:19:27 -0400
Message-ID: <486CDFE5.9030105@atmel.com>
Date: Thu, 03 Jul 2008 16:19:17 +0200
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
CC: Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       VILCHEZ Patrice <Patrice.VILCHEZ@atmel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Support for the at91sam9g20 : Atmel 400Mhz ARM 926ej-s
 SOC
References: <4852324C.9000604@atmel.com> <20080703133244.GB17201@flint.arm.linux.org.uk>
In-Reply-To: <20080703133244.GB17201@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
>   
>> +/*
>> + * MCI (SD/MMC)
>> + */
>> +static struct at91_mmc_data __initdata ek_mmc_data = {
>> +	.slot_b		= 1,
>> +	.wire4		= 1,
>> +//	.det_pin	= ... not connected
>> +//	.wp_pin		= ... not connected
>> +//	.vcc_pin	= ... not connected
>>     
>
> Please make these a proper comment, preferably inside the comment before
> the structure.  C++ comments are frowned upon in the kernel's source.
>
>   
I would like to know what do you suggest about this comment? Indeed we 
already use this kind of comments, for instance in board-sam9260ek.c. I 
don't mind changing it into the proper comment form, but I would like to 
know first what do you suggest.

Regards,
Sedji

