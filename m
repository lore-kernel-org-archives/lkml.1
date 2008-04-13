Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYDMSuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYDMSuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYDMSuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:50:06 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:60651 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752037AbYDMSuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:50:05 -0400
Message-ID: <4802560D.3020308@seznam.cz>
Date: Sun, 13 Apr 2008 20:50:53 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
CC: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, benh@kernel.crashing.org,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <20080413101304.308f6c1a@zod.rchland.ibm.com>
In-Reply-To: <20080413101304.308f6c1a@zod.rchland.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

>> Hi Everybody,
>>
>> I fixed all reported bugs which I got from LKML and from you.
>> Latest version of Microblaze Linux kernel is available at git.monstr.eu.
>> There is git repository called linux-microblaze.git
>> Microblaze port is based on 2.6.24-rc5. I'll create the new repo with clean pack
>> of changes based on latest kernel version for easier pull.
>>
>> Merge windows will be open hopefully next week and I would like to send pull
>> request to Paul.
> 
> Why Paul?  If microblaze is a new architecture (which it seems to be),
> then you should really work through Linus directly.

I don't know who start with it. For me is not this point important.
I think that was Steve's idea, wasn't it?

> Also, which version of gcc/binutils are needed to actually build this?

I personally use gcc from Petalogix distribution. For non-MMU kernel v3.4.1. for
MMU kernel I think 4.1.1. (MMU port for Microblaze FDT kernel will come later).
You can download whole distribution from developer.petalogix.com.

Michal Simek
www.monstr.eu
