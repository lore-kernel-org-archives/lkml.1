Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbYBPTjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbYBPTjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYBPTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:39:05 -0500
Received: from www.tglx.de ([62.245.132.106]:41948 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYBPTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:39:04 -0500
Date: Sat, 16 Feb 2008 20:38:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/5] Enable ACPI extended century handling for 32bit
 too v2
In-Reply-To: <20080209151701.56CAB1B41D1@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802162038310.7583@apollo.tec.linutronix.de>
References: <20080209416.271135970@suse.de> <20080209151701.56CAB1B41D1@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Andi Kleen wrote:
> 
> Not that it matters much, see comment in the code.
> 
> v2: Fix compilation on !ACPI, pointed out by tglx
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Applied. Thanks,

	 tglx
