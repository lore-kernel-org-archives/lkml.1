Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbYIFRrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbYIFRrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYIFRrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:47:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbYIFRri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:47:38 -0400
Date: Sat, 6 Sep 2008 19:47:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: pgd_{c,d}tor() cleanup
Message-ID: <20080906174721.GQ4856@elte.hu>
References: <48B7FEE4.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B7FEE4.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0559]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Giving pgd_ctor() a properly typed parameter allows eliminating a local
> variable. Adjust pgd_dtor() to match.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>

applied to tip/x86/cleanups, thanks Jan.

	Ingo
