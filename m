Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbYDEBbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbYDEBbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYDEBam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:30:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:58137 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbYDEBal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dVtnn6SNOcpXF7kZw6/FZDmECjSdW/It9fZZS2HG+muIpzpqNSljbRBFKhtKKN+lvkEN6FpBiToPQY/PPdwir4jnWqhyYhiiot7tX8nV2y3N2tQmvpaAVVnx7aHsFkkXIHl5C8cmpkeROG91MoAbEKMl1zMj4T8xS85kz+1zIJM=
Message-ID: <47F6D611.5080402@gmail.com>
Date: Sat, 05 Apr 2008 05:29:53 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] [MIPS] unexport null_perf_irq() and make it static
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com> <1207094318-21748-6-git-send-email-dmitri.vorobiev@gmail.com> <20080404072048.GF12086@linux-mips.org>
In-Reply-To: <20080404072048.GF12086@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle пишет:
> On Wed, Apr 02, 2008 at 03:58:38AM +0400, Dmitri Vorobiev wrote:
> 
>> This patch unexports the null_perf_irq() symbol, and simultaneously
>> makes this function static.
>>
>> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
> 
> Queued for 2.6.26 with your static fix folded in.  Thanks,

Thanks for picking the patches up.

Dmitri

> 
>   Ralf
> 


