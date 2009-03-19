Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbZCSHdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbZCSHdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZCSHdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:33:15 -0400
Received: from www.tglx.de ([62.245.132.106]:52584 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZCSHdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:33:15 -0400
Date: Thu, 19 Mar 2009 08:32:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] one extra (incorrect) test in mask_ack_irq()
In-Reply-To: <49C1AB0E.5060800@am.sony.com>
Message-ID: <alpine.LFD.2.00.0903190831490.29264@localhost.localdomain>
References: <49C1AB0E.5060800@am.sony.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank,

On Wed, 18 Mar 2009, Frank Rowand wrote:
> preempt-irqs-core.patch added an incorrect check for the existence of
> desc->chip->ack to mask_ack_irq()

Applied. Thanks,

	 tglx


