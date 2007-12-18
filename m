Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXLRN7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXLRN7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXLRN67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:58:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326AbXLRN66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:58:58 -0500
Date: Tue, 18 Dec 2007 14:58:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: bjorn.helgaas@hp.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch 3/3] PCI: use dev_printk in x86 quirk messages
Message-ID: <20071218135801.GB17470@elte.hu>
References: <20071217210937.103111394@ldl.fc.hp.com> <20071217211337.545932066@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217211337.545932066@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* bjorn.helgaas@hp.com <bjorn.helgaas@hp.com> wrote:

> Convert quirk printks to dev_printk().

thanks, applied the x86 bits.

	Ingo
