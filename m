Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0BCKxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 05:53:44 -0500
Received: from relay.bearnet.nu ([80.252.223.222]:4776 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab0BCKxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 05:53:43 -0500
Message-ID: <4B6955AE.1090709@pelagicore.com>
Date: Wed, 03 Feb 2010 11:53:34 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100121 Iceowl/1.0b1 Icedove/3.0.1
MIME-Version: 1.0
To: Samuel Ortiz <samuel.ortiz@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] mfd: Add support for the timberdale FPGA.
References: <4B694463.6050306@pelagicore.com> <20100203104448.GB3460@sortiz.org>
In-Reply-To: <20100203104448.GB3460@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 11:45 AM, Samuel Ortiz wrote:
> Hi Richard,
>
> On Wed, Feb 03, 2010 at 09:39:47AM +0000, Richard Röjfors wrote:
>> The timberdale FPGA is found on the Intel in-Vehicle Infotainment reference board
>> russelville.
>>
>> The driver is a PCI driver which chunks up the I/O memory and distributes interrupts
>> to a number of platform devices for each IP inside the FPGA.
>>
>> Signed-off-by: Richard Röjfors<richard.rojfors@pelagicore.com>
> The patch looks good to me, I have a couple of minor comments though:
>
> - Please replace most of your printk with dev_dbg/err()

Agreed.

> - Please fix your checkpatch output:
> total: 255 errors, 18 warnings, 822 lines checked

Sweet, the mail client changed all tabs to spaces when resending the patch.

--Richard

