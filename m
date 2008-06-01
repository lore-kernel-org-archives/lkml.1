Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYFAUg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYFAUg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYFAUgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:36:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39382 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYFAUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:36:16 -0400
Date: Sun, 1 Jun 2008 21:36:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080601203603.GA29022@srcf.ucam.org>
References: <20080529124548.GC8065@mit.edu> <20080529.135431.235149338.davem@davemloft.net> <20080529211404.GH8065@mit.edu> <20080529.143921.34376298.davem@davemloft.net> <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de> <20080601181706.GB26477@srcf.ucam.org> <alpine.LFD.1.10.0806012221170.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806012221170.3235@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 10:22:48PM +0200, Thomas Gleixner wrote:

> And why wouldn't it be a good idea to spend time on adding the video
> reinit right there at the hacking session ?

Because there's only one guy outside nvidia who understands the nvidia 
BIOS tables right now, and I suspect he's not on the invite list :) I'm 
actually planning on giving the nvidia stuff a go this week.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
