Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbYD3GMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbYD3GMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbYD3GL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:11:59 -0400
Received: from www.tglx.de ([62.245.132.106]:57269 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023AbYD3GL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:59 -0400
Date: Wed, 30 Apr 2008 08:11:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-git WARNING: at arch/x86/kernel/genapic_64.c:86
 read_apic_id+0x2e/0x46()
In-Reply-To: <4817B67A.40308@gmail.com>
Message-ID: <alpine.LFD.1.10.0804300811140.6003@apollo.tec.linutronix.de>
References: <4817B67A.40308@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Kevin Winchester wrote:

> 
> Hi Ingo,
> 
> I am getting the following in my dmesg on every boot.  It was reported
> before[1], so I figured someone was working on it.  However, I haven't seen it
> get fixed yet, so is there anything I can do to help?

Fix is queued for Linus to pull.

Thanks,
	tglx
