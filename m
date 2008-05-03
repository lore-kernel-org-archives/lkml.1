Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYECVI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYECVI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYECVIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:08:19 -0400
Received: from www.tglx.de ([62.245.132.106]:48401 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYECVIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:08:18 -0400
Date: Sat, 3 May 2008 23:07:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: nmi and irq counters are unsigned
In-Reply-To: <481BA774.5090004@ct.jp.nec.com>
Message-ID: <alpine.LFD.1.10.0805032307280.6003@apollo.tec.linutronix.de>
References: <481BA774.5090004@ct.jp.nec.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> __nmi_count, apic_timer_irqs and irq0_irqs are unsigned.

Applied. Thanks,

	 tglx
 
