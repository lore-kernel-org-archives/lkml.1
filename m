Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZEONHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZEONHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbZEONH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:07:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZEONH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:07:28 -0400
Date: Fri, 15 May 2009 15:06:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/acpi: remove compress irq trick for 32bit
Message-ID: <20090515130659.GA31171@elte.hu>
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E80457.5060403@kernel.org> <alpine.LFD.2.00.0904230039420.21119@localhost.localdomain> <49F4D7CB.4040406@kernel.org> <alpine.LFD.2.00.0905141140000.19537@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905141140000.19537@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Len Brown <lenb@kernel.org> wrote:

> Yinghai,
> I'm really happy to see this workaround finally get removed.
> 
> Acked-by: Len Brown <len.brown@intel.com>
> 
> Ingo,
> go ahead and keep this with your irq patches.

thanks Len!

	Ingo
