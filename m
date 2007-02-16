Return-Path: <linux-kernel-owner+w=401wt.eu-S1945913AbXBPPTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945913AbXBPPTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945920AbXBPPTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:19:46 -0500
Received: from www.osadl.org ([213.239.205.134]:44291 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945913AbXBPPTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:19:45 -0500
Subject: Re: + small-irq-management-simplification.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: akpm@linux-foundation.org
Cc: jbeulich@novell.com, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200702142326.l1ENQZTN012664@shell0.pdx.osdl.net>
References: <200702142326.l1ENQZTN012664@shell0.pdx.osdl.net>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 16:24:27 +0100
Message-Id: <1171639467.30834.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 15:26 -0800, akpm@linux-foundation.org wrote:
> Subject: small irq management simplification
> From: "Jan Beulich" <jbeulich@novell.com>
> 
> Use mask_ack_irq() where possible.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


