Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYFRL7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYFRL7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYFRL6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:58:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbYFRL6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:58:34 -0400
Date: Wed, 18 Jun 2008 13:58:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Assmann <sassmann@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ihno Krumreich <ihno@suse.de>,
       Sven Dietrich <sdietrich@suse.de>, Daniel Gollub <dgollub@suse.de>,
       Felix Foerster <ffoerster@suse.de>
Subject: Re: [PATCH 0/5] Boot IRQ quirks and rerouting [repost]
Message-ID: <20080618115819.GA13714@elte.hu>
References: <12131949173532-git-send-email-sassmann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12131949173532-git-send-email-sassmann@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Stefan Assmann <sassmann@suse.de> wrote:

> These patches are against linux-2.6-tip, auto-x86-next.
> 
> The AMD/ATI and Broadcomm patches are not included yet, we're working 
> on getting things ready for submission.
> 
> The patch for the bootirqquirk= parameter will be released later.

applied, thanks Stefan. I have created a new 
tip/x86/pci-ioapic-boot-irq-quirks topic branch for this. Lets see how 
these changes work out in practice.

	Ingo
