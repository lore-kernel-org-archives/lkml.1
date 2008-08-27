Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYH0GZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYH0GZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYH0GZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:25:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYH0GZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:25:38 -0400
Date: Wed, 27 Aug 2008 08:25:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       John Keller <jpk@sgi.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [RESEND][PATCH -tip] x86: acpi: move acpi_mcfg_64bit_base_addr
	into CONFIG_PCI_MMCONFIG
Message-ID: <20080827062522.GB6255@elte.hu>
References: <48B48019.6080803@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B48019.6080803@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> acpi_mcfg_64bit_base_addr is used when CONFIG_PCI_MMCONFIG is enabled.

applied to tip/x86/cleanups, thanks!

	Ingo
