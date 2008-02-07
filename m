Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbYBGRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbYBGRQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbYBGRQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:16:41 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:49030 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbYBGRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:16:40 -0500
Message-ID: <47AB3CF1.5020905@freescale.com>
Date: Thu, 07 Feb 2008 11:16:33 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Zhang Wei <Wei.Zhang@freescale.com>,
       Dan Williams <dan.j.williams@intel.com>
CC: linux-kernel@vger.kernel.org, Zhu Ebony <ebony.zhu@freescale.com>,
       galak@kernel.crashing.org
Subject: Re: [PATCH v2] Add DMA engine driver for Freescale MPC85xx processors.
References: <e9c3a7c20801101021n7aa37bdrd6255245a773546e@mail.gmail.com> <ABF87B0B6A38C0458E319AC973ED68AEB82A57@zch01exm26.fsl.freescale.net>
In-Reply-To: <ABF87B0B6A38C0458E319AC973ED68AEB82A57@zch01exm26.fsl.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Wei wrote:
> Hi, Dan, 
> 
>> -----Original Message-----
>> From: dan.j.williams@gmail.com 
>>
>> I do not think all the review comments have been addressed, for
>> example my earlier comments about GFP_ATOMIC and spin_lock_irqsave
>> [1].  We have two options to take this forward:
>>
> 
> Thanks! Some comments need more study, I'll discuss them with you later.

Zhang and Dan,

What's the status on this patch?  Will it make 2.6.25?

-- 
Timur Tabi
Linux kernel developer at Freescale
