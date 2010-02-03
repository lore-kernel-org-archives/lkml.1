Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0BCMi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:38:57 -0500
Received: from relay.bearnet.nu ([80.252.223.222]:4959 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab0BCMix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:38:53 -0500
Message-ID: <4B696E54.20501@pelagicore.com>
Date: Wed, 03 Feb 2010 13:38:44 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100121 Iceowl/1.0b1 Icedove/3.0.1
MIME-Version: 1.0
To: Samuel Ortiz <samuel.ortiz@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] mfd: Add support for the timberdale FPGA.
References: <4B694463.6050306@pelagicore.com> <20100203104448.GB3460@sortiz.org> <4B6955AE.1090709@pelagicore.com> <20100203123218.GE3460@sortiz.org>
In-Reply-To: <20100203123218.GE3460@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 01:32 PM, Samuel Ortiz wrote:
> On Wed, Feb 03, 2010 at 10:53:34AM +0000, Richard Röjfors wrote:
>> On 02/03/2010 11:45 AM, Samuel Ortiz wrote:
>>> Hi Richard,
>>>
>>> On Wed, Feb 03, 2010 at 09:39:47AM +0000, Richard Röjfors wrote:
>>>> The timberdale FPGA is found on the Intel in-Vehicle Infotainment reference board
>>>> russelville.
>>>>
>>>> The driver is a PCI driver which chunks up the I/O memory and distributes interrupts
>>>> to a number of platform devices for each IP inside the FPGA.
>>>>
>>>> Signed-off-by: Richard Röjfors<richard.rojfors@pelagicore.com>
>>> The patch looks good to me, I have a couple of minor comments though:
>>>
>>> - Please replace most of your printk with dev_dbg/err()
>>
>> Agreed.
>>
>>> - Please fix your checkpatch output:
>>> total: 255 errors, 18 warnings, 822 lines checked
>>
>> Sweet, the mail client changed all tabs to spaces when resending the patch.
> Actually, your first patch to the linux-media ml also had tabs changed into
> spaces.

I'm getting confused. I checked my sent mail and the one I got from the
media mailinglist and none of these had spaces in it.
Is there a problem with your mail client?

I'll send the updated patch off list first to verify.

--Richard

