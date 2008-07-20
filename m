Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYGTILY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYGTILY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 04:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYGTILL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 04:11:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYGTILK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 04:11:10 -0400
Date: Sun, 20 Jul 2008 10:10:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH] x86: Add unknown_nmi_panic kernel parameter
Message-ID: <20080720081036.GB19583@elte.hu>
References: <48826B96.1070900@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48826B96.1070900@simon.arlott.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Arlott <simon@fire.lp0.eu> wrote:

> It's not possible to enable the unknown_nmi_panic sysctl option until 
> init is run. It's useful to be able to panic the kernel during boot 
> too, this adds a parameter to enable this option.
>
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

applied to tip/x86/nmi, thanks Simon.

	Ingo
