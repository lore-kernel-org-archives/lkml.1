Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYFAUXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYFAUXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYFAUXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:23:04 -0400
Received: from www.tglx.de ([62.245.132.106]:40055 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYFAUXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:23:04 -0400
Date: Sun, 1 Jun 2008 22:22:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
In-Reply-To: <20080601181706.GB26477@srcf.ucam.org>
Message-ID: <alpine.LFD.1.10.0806012221170.3235@apollo.tec.linutronix.de>
References: <20080529124548.GC8065@mit.edu> <20080529.135431.235149338.davem@davemloft.net> <20080529211404.GH8065@mit.edu> <20080529.143921.34376298.davem@davemloft.net> <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de>
 <20080601181706.GB26477@srcf.ucam.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008, Matthew Garrett wrote:

> On Sun, Jun 01, 2008 at 04:11:01PM +0200, Thomas Gleixner wrote:
> 
> > Fix NOHZ/CPUIDLE along with suspend/resume on all participants
> > laptops, which are probably 50+ different models. That'd be an odd
> > enough mix of wreckaged hardware / BIOS / ACPI.
> 
> If we have in-kernel video reinit for the major vendors by then, sure. 
> If not, I suspect the majority of issues we'd hit would just be "My 
> screen doesn't come back".

And why wouldn't it be a good idea to spend time on adding the video
reinit right there at the hacking session ?

Thanks,

	tglx
