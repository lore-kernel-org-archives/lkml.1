Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbXJTKvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbXJTKvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 06:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbXJTKvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 06:51:43 -0400
Received: from www.tglx.de ([62.245.132.106]:38670 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756964AbXJTKvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 06:51:43 -0400
Date: Sat, 20 Oct 2007 12:50:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: vgoyal@in.ibm.com, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/3] x86: unify crash_32/64.c
In-Reply-To: <47195763.1090803@ct.jp.nec.com>
Message-ID: <alpine.LFD.0.9999.0710201249050.22770@localhost.localdomain>
References: <47195763.1090803@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Hiroshi Shimamoto wrote:

> Hi,
> 
> I made patches to unify crash_32/64.c.
> There are three patches;
> 1. add lapic_shutdown for x86_64
> 2. add safe_smp_processor_id for x86_64
> 3. unify crash_32/64.c
> 
> I'm not sure that it's good to split to these patches.

It's fine. So the steps leading to unification are clear.

Applied. Thanks,

	 tglx


	
