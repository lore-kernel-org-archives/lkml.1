Return-Path: <linux-kernel-owner+w=401wt.eu-S1765263AbYBAMZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765263AbYBAMZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763800AbYBAMZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:25:49 -0500
Received: from www.tglx.de ([62.245.132.106]:44486 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763594AbYBAMZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:25:48 -0500
Date: Fri, 1 Feb 2008 13:25:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/12] GBPAGES patchkit for 2.6.25 v3
In-Reply-To: <200802011053.107168490@suse.de>
Message-ID: <alpine.LFD.1.00.0802011324260.9204@apollo.tec.linutronix.de>
References: <200802011053.107168490@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Andi Kleen wrote:

> 
> This patchkit implements support for the 1GB pages of AMD Fam10h CPUs 
> in the kernel direct mapping. 
> 
> Change to previous versions:
> - Incorporated feedback from Thomas Gleixner
> - Switch direct mapping setup over to set_pte() / pte_pfn()
> - Split up patches some more
> 
> Includes one not strictly required cleanup patch now (the last one) 

I picked them up. Will go through and integrate with other
changes in this area.

Thanks,
	tglx
