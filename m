Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZETNTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZETNTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZETNTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:19:02 -0400
Received: from emulex.emulex.com ([138.239.112.1]:36250 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZETNTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:19:01 -0400
Message-ID: <4A13FD75.6050100@emulex.com>
Date: Wed, 20 May 2009 08:54:13 -0400
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <tomof@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <Jens.Axboe@oracle.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
 block/for-2.6.31 tree
References: <4A12797B.2060901@panasas.com>	<4A12AC23.30808@panasas.com> <20090520111619.87f815b1.sfr@canb.auug.org.au> <4A13BB1D.10901@panasas.com>
In-Reply-To: <4A13BB1D.10901@panasas.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2009 12:54:15.0829 (UTC) FILETIME=[14E77450:01C9D94A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fine by me.

-- james s

Acked-by: James Smart <james.smart@emulex.com>


Boaz Harrosh wrote:
> On 05/20/2009 04:16 AM, Stephen Rothwell wrote:
>   
>> On Tue, 19 May 2009 15:54:59 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
>>     
>>> This patch should be squashed into
>>>     [SCSI] FC Pass Thru support
>>>
>>> If it needs to compile after Tejun's block-layer revamps
>>> (all of them)
>>>       
>> Is there some reason that the FC passthrough support (and any followup
>> patches) can't be pushed through the block tree.  It clearly currently
>> doesn't depend on anything new in the scsi tree ...
>>
>>     
>
> If it will go through block tree it needs James Bottomley's Ack, I
> guess?
>
> It does, in any case, need Ack from James Smart first. James ?
>
> Thanks
> Boaz
>
>   
