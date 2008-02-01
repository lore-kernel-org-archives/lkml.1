Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYBAMY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYBAMY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYBAMYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:24:48 -0500
Received: from www.tglx.de ([62.245.132.106]:44451 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYBAMYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:24:48 -0500
Date: Fri, 1 Feb 2008 13:24:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Huang, Ying" <ying.huang@intel.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: set_memory_xx enhancement
In-Reply-To: <1201858482.4051.16.camel@caritas-dev.intel.com>
Message-ID: <alpine.LFD.1.00.0802011323360.9204@apollo.tec.linutronix.de>
References: <1201858482.4051.16.camel@caritas-dev.intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Huang, Ying wrote:

> This patchset enhances set_memory_xx functions and updates its usage
> such as EFI accordingly.
> 
> This patchset is based on latest x86 git tree and has been tested on
> EFI 32 and EFI 64 platform.

I picked up your patches and try to integrate them with changes I was
working on.

Thanks,
	tglx
