Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXBSQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXBSQgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932399AbXBSQgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:36:49 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:50691 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbXBSQgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:36:48 -0500
Date: Mon, 19 Feb 2007 08:36:24 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] i386 make NMI use PERFCTR1 for architectural perfmon
Message-ID: <20070219163624.GB30233@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070217160656.GA16715@frankl.hpl.hp.com> <200702181756.05672.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702181756.05672.ak@suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Sun, Feb 18, 2007 at 05:56:05PM +0100, Andi Kleen wrote:
> On Saturday 17 February 2007 17:06, Stephane Eranian wrote:
> > Hello,
> > 
> > This patch against 2.6.20 
> 
> Please always submit against mainline:
> 
Isn't 2.6.20 the latest mainline?

> patching file arch/i386/kernel/nmi.c
> Hunk #1 FAILED at 288.
> Hunk #2 succeeded at 740 (offset 55 lines).
> Hunk #3 succeeded at 1017 with fuzz 1 (offset 59 lines).
> 1 out of 3 hunks FAILED -- rejects in file arch/i386/kernel/nmi.c
> Patch patches/i386-make-nmi-use-perfctr1-for-architectural-perfmon does not apply (enforce with -f)
> 
Maybe I messed up my original tree. Do you want me to resubmit?

Sorry about that.

-- 
-Stephane
