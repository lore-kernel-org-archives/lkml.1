Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZGFJkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZGFJkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZGFJjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:39:55 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64494 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbZGFJjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:39:55 -0400
Message-ID: <4A51C65D.90304@atmel.com>
Date: Mon, 06 Jul 2009 11:39:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk, kernel@avr32linux.org,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: add two new at91 to cpu.h definition
References: <1246875312-6824-1-git-send-email-nicolas.ferre@atmel.com> <20090706111954.723badb9@hskinnemoen-d830>
In-Reply-To: <20090706111954.723badb9@hskinnemoen-d830>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen :
> Nicolas Ferre wrote:
>> Somme common drivers will need those at91 cpu_is_xxx() definitions. As
>> at91sam9g10 and at91sam9g45 are on the way to linus' tree, here is the patch
>> that adds those chips to cpu.h in AVR32 architecture.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> 
>> ---
>> Inclusion in linux-2.6-arm.git/devel:
>>
>> at91sam9g10: b784b7c03723891876c9053c589150a4062f9455
>> at91sam9g45: fddcc0ae58edefeb7ac1e460411d7dfbe8ebdacc
> 
> Do you want me to take this patch, or is it better if it goes in along
> the rest through the ARM tree?

You can take this patch as it will still go in linux-next.

I try to collect all patches that are related to those products
introduction in linux-next (for 2.6.32).

Thanks Haavard. Bye,
-- 
Nicolas Ferre

