Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYCCKof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYCCKof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYCCKo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:44:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbYCCKo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:44:28 -0500
Date: Mon, 3 Mar 2008 11:44:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86: potential ioremap() issues
Message-ID: <20080303104407.GD21190@elte.hu>
References: <47C6BE37.76E4.0078.0@novell.com> <20080228132404.GB18551@elte.hu> <6101e8c40802291404u49037ad9u4347f552ce72bf28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802291404u49037ad9u4347f552ce72bf28@mail.gmail.com>
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


* Oliver Pinter <oliver.pntr@gmail.com> wrote:

> Hi Ingo!
> 
> this patch is needed for 2.6.22 kernel? I see, this code in 
> arch/x86_64/mm/ioremap.c

no, should not be needed - these are extra warnings in .25.

	Ingo
