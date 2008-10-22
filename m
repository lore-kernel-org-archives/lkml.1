Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYJVP0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYJVP0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJVP0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:26:41 -0400
Received: from mail.atmel.fr ([81.80.104.162]:62890 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYJVP0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:26:40 -0400
Message-ID: <48FF4617.80204@atmel.com>
Date: Wed, 22 Oct 2008 17:26:15 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH] dmaengine: at_hdmac: new driver for the Atmel AHB DMA
 Controller
References: <48F8B291.1060500@atmel.com> <7F38996F7185A24AB9071ED4950AD8C1022288C6@swsmsx413.ger.corp.intel.com>
In-Reply-To: <7F38996F7185A24AB9071ED4950AD8C1022288C6@swsmsx413.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sosnowski, Maciej :
> Nicolas Ferre wrote:
>> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is
>> availlable on 
>> at91sam9rl chip. It will be used on other products in the future.
>>
>> This first release covers only the memory-to-memory tranfer type.
>> This is the 
>> only tranfer type supported by this chip.
>> On other products, it will be used also for peripheral DMA transfer
>> (slave API 
>> support to come).
>>
>> I used dmatest client without problem in different configurations to
>> test 
>> it.
>>
>> Full documentation for this controller can be found in the SAM9RL
>> datasheet :
>> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243 
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
> 
> Hi Nicolas,
> I have walked through the code and I do not see any serious problems
> here.

Great !
Thanks for your feedback.


> Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> 

Kind regards,
-- 
Nicolas Ferre

