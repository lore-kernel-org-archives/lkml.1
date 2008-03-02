Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYCBTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYCBTwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYCBTwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:52:06 -0500
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:53844 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753179AbYCBTwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:52:05 -0500
X-Greylist: delayed 1535 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 14:52:05 EST
Message-ID: <47CAFF27.9030506@seznam.cz>
Date: Sun, 02 Mar 2008 20:25:27 +0100
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: John Williams <john.williams@petalogix.com>, monstr@monstr.eu,
       linux-kernel@vger.kernel.org
Subject: Re: [microblaze-uclinux] RE: [PATCH 24/52] [microblaze] time support
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu> <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu> <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu> <010fc233f82a8f7a591c9f8315ae03f9951139aaeu> <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu> <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu> <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu> <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu> <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu> <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu> <47BD86F3.9030400@petalogix.com> <20080221163040.5E9FA6A0056@mail168-sin.bigfish.com>
In-Reply-To: <20080221163040.5E9FA6A0056@mail168-sin.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK.

I will wait for it.


Michal

> 
> There's also a pretty stupid one in the tree at git.xilinx.com.
> 
> Steve
> 
> -----Original Message-----
> From: John Williams [mailto:john.williams@petalogix.com]
> Sent: Thu 2/21/2008 6:13 AM
> To: monstr@monstr.eu
> Cc: linux-kernel@vger.kernel.org; Stephen Neuendorffer;
> microblaze-uclinux@itee.uq.edu.au
> Subject: Re: [PATCH 24/52] [microblaze] time support
> 
> Hi Michal,
> 
> monstr@monstr.eu wrote:
> 
> 
>> --- /dev/null
>> +++ b/include/asm-microblaze/delay.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + * include/asm-microblaze/delay.h
>> + *
> 
>> +
>> +static inline void udelay(unsigned long usec)
>> +{
>> +}
> 
> We need a proper udelay implementation.  I've got a semi-reasonable one
> in a private branch somewhere, will dig it out and send it to you.
> 
> Cheers,
> 
> John
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> No virus found in this incoming message.
> Checked by AVG Free Edition. 
> Version: 7.5.516 / Virus Database: 269.21.3/1306 - Release Date: 1.3.2008 05:41
