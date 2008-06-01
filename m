Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYFASRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYFASRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 14:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbYFASRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 14:17:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52960 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYFASRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 14:17:16 -0400
Date: Sun, 1 Jun 2008 19:17:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080601181706.GB26477@srcf.ucam.org>
References: <20080529124548.GC8065@mit.edu> <20080529.135431.235149338.davem@davemloft.net> <20080529211404.GH8065@mit.edu> <20080529.143921.34376298.davem@davemloft.net> <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 04:11:01PM +0200, Thomas Gleixner wrote:

> Fix NOHZ/CPUIDLE along with suspend/resume on all participants
> laptops, which are probably 50+ different models. That'd be an odd
> enough mix of wreckaged hardware / BIOS / ACPI.

If we have in-kernel video reinit for the major vendors by then, sure. 
If not, I suspect the majority of issues we'd hit would just be "My 
screen doesn't come back".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
