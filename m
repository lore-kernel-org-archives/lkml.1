Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbYGSHct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbYGSHct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 03:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYGSHcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 03:32:42 -0400
Received: from www.tglx.de ([62.245.132.106]:57478 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbYGSHcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 03:32:42 -0400
Date: Sat, 19 Jul 2008 09:32:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: eric miao <eric.y.miao@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jack Ren <jack.ren@marvell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
In-Reply-To: <20080718162905.GA4781@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.10.0807190923180.4316@apollo.tec.linutronix.de>
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com> <20080718102446.GV6875@elte.hu> <alpine.LFD.1.10.0807181548290.4316@apollo.tec.linutronix.de> <f17812d70807180738r75696e0ak120a884328b68ed3@mail.gmail.com>
 <alpine.LFD.1.10.0807181647500.4316@apollo.tec.linutronix.de> <20080718162905.GA4781@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Heiko Carstens wrote:
> On Fri, Jul 18, 2008 at 05:27:28PM +0200, Thomas Gleixner wrote:
> > Can you give the patch below a try please ?
> 
> If this patch works, could you also add the s390 hunk before submitting?

Sure. It should have been there already :(

Thanks,
	tglx
 
