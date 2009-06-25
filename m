Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZFYPZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZFYPZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZFYPZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:25:04 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:37320 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZFYPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:25:03 -0400
Message-ID: <4A4396CB.9000703@free-electrons.com>
Date: Thu, 25 Jun 2009 17:24:59 +0200
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: Mike Rapoport <mike@compulab.co.il>, Alain Knaff <alain@knaff.lu>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-embedded mailing list <linux-embedded@vger.kernel.org>
Subject: Re: Status of bzip2 and lzma kernel compression for ARM?
References: <4A428AFF.20307@free-electrons.com> <4A433BCD.2030506@compulab.co.il> <200906251104.02830.florian@openwrt.org>
In-Reply-To: <200906251104.02830.florian@openwrt.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2009 11:04 AM, Florian Fainelli wrote:
> Le Thursday 25 June 2009 10:56:45 Mike Rapoport, vous avez écrit :
>> I'm not sure what exactly do you mean by "test bzip2 and lzma compression
>> on ARM", but if you refer to internal initramfs compression, I can tell
>> that I've used lzma compression on PXA270 and it works fine.
>>     
>
> I think Michael refers to the lzma decompressor which allows you to use a 
> lzma-compressed kernel as a (b)zImage with its architecture specific 
> decompressor piggy-backed in the (b)zImage.
>
> Such thing would also be very useful on MIPS and PowerPC as well.
>   
Yes, that's what I meant: using a bzip2 or lzma compressed kernel. I
would like to know the boot time impact on an ARM board.

If I don't get any answer from Alain in the next days, I will propose a
patch update for ARM.

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com

