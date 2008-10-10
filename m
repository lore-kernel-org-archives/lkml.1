Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYJJLP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYJJLP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYJJLPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:15:21 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:46920 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYJJLPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:15:20 -0400
Date: Fri, 10 Oct 2008 12:15:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
In-Reply-To: <20081010090100.GC319@elte.hu>
Message-ID: <alpine.LFD.1.10.0810101214010.19747@ftp.linux-mips.org>
References: <20081010002203.GA23238@linux-os.sc.intel.com> <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com> <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
 <20081010090100.GC319@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Ingo Molnar wrote:

> So .. how about just standardizing on the divisor of 16 on both 32-bit 
> and 64-bit?

 I'd second that -- the less code divergence the better.

  Maciej
