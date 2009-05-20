Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZETILg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZETILg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZETILT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:11:19 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:57212 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZETILR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lT9jrIg6yu+X7Z+4itCOy8GocWJYP/tW04Pfm3RejabztpznnMKAMUWAFlrQ8EArFv
         O6O2fanx3gOzRBJvqB8n+nSX7VVrUjsUixGNfr7/YAuCNjT6msRg78QPjECK6lXS5iGi
         k1x0gpU+6DaMWK3cRTX/kQn9YPdPUagAiUS7M=
Message-ID: <4A13BB1D.10901@panasas.com>
Date: Wed, 20 May 2009 11:11:09 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       James Smart <James.Smart@Emulex.Com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <tomof@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <Jens.Axboe@oracle.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
 block/for-2.6.31 tree
References: <4A12797B.2060901@panasas.com>	<4A12AC23.30808@panasas.com> <20090520111619.87f815b1.sfr@canb.auug.org.au>
In-Reply-To: <20090520111619.87f815b1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2009 04:16 AM, Stephen Rothwell wrote:
> On Tue, 19 May 2009 15:54:59 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> This patch should be squashed into
>>     [SCSI] FC Pass Thru support
>>
>> If it needs to compile after Tejun's block-layer revamps
>> (all of them)
> 
> Is there some reason that the FC passthrough support (and any followup
> patches) can't be pushed through the block tree.  It clearly currently
> doesn't depend on anything new in the scsi tree ...
> 

If it will go through block tree it needs James Bottomley's Ack, I
guess?

It does, in any case, need Ack from James Smart first. James ?

Thanks
Boaz

