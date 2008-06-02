Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYFBJan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYFBJan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYFBJae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:30:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYFBJae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:30:34 -0400
Date: Mon, 2 Jun 2008 11:30:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bertram Felgenhauer <int-e@gmx.de>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: Add workaround for bug in ASUS A7V600 BIOS (rev
	1005)
Message-ID: <20080602093015.GA25008@elte.hu>
References: <20080530012005.GA9514@zombie.inf.tu-dresden.de> <20080530103605.1e56fac1@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530103605.1e56fac1@core>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri, 30 May 2008 03:20:05 +0200
> Bertram Felgenhauer <int-e@gmx.de> wrote:
> 
> > This BIOS claims the VIA 8237 south bridge to be compatible with VIA 586,
> > which it is not.
> > 
> > Signed-off-by: Bertram Felgenhauer <int-e@gmx.de>
> 
> Looks fine to me
> 
> Acked-by: Alan Cox <alan@redhat.com>

applied to tip/pci-for-jesse - thanks.

	Ingo
