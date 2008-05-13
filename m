Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbYEMVPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbYEMVPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbYEMVPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:15:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbYEMVPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:15:01 -0400
Message-ID: <482A0199.4070400@zytor.com>
Date: Tue, 13 May 2008 14:01:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] x86 fixes
References: <20080513192706.GA13677@elte.hu> <20080513194018.GA14569@cs181133002.pp.htv.fi>
In-Reply-To: <20080513194018.GA14569@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> See my comment below (and I'd really appreciate if such stuff was sent 
> to the mailing list before the pull request for being able to comment
> in time).
> 
>> Takashi Iwai (1):
>>       x86/pci: fix broken ISA DMA
> 
> Linus already got the latter through the PCI tree,
> 
> Who is actually responsible for the x86 PCI stuff?
> 

PCI is Jesse Barnes, but this is peripheral to both PCI and x86...

	-hpa
