Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbYDZUb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbYDZUb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYDZUbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:31:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbYDZUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:31:20 -0400
Date: Sat, 26 Apr 2008 13:30:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, bootmem/sparsemem, #2
In-Reply-To: <20080426200829.GB14223@elte.hu>
Message-ID: <alpine.LFD.1.10.0804261330160.2813@woody.linux-foundation.org>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426194143.GA8366@elte.hu> <alpine.LFD.1.10.0804261247020.2813@woody.linux-foundation.org> <20080426200829.GB14223@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Ingo Molnar wrote:
> 
> here's the updated tree:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-bootmem-v2.git for-linus

Ok, this clashes with the bootparam changes..

		Linus
