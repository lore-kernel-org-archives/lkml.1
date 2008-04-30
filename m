Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbYD3Vm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbYD3Vm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYD3VmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:42:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308AbYD3VmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:42:18 -0400
Message-ID: <4818E777.2070702@zytor.com>
Date: Wed, 30 Apr 2008 14:41:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: dmitri.vorobiev@gmail.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove NexGen support (fwd)
References: <20080429081729.GA3921@ucw.cz> <20080430213457.GD18536@elf.ucw.cz>
In-Reply-To: <20080430213457.GD18536@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> It is claimed that NexGen CPUs were never shipped:
>>
>> http://lkml.org/lkml/2008/4/20/179
>>
>> Also, the kernel support for these chips has been broken for
>> a long time, the code intended to support NexGen thereby being
>> essentially dead.
> 
> Are you sure it never shipped? Wikipedia seems to suggest it did ship.
> 
> http://www.cpu-info.com/index2.php?mainid=Nx586&page=5
> 
> ...FPU for nexgen was never shipped, that implies that CPU did ship.
> 

Doesn't mean it shipped in anything other than sample or sample-like 
quantities.

	-hpa
