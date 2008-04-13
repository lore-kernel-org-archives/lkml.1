Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYDMHfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYDMHfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYDMHfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:35:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59549 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYDMHfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:35:03 -0400
Date: Sun, 13 Apr 2008 09:34:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: Re: [PATCH 0/3] x86: more section mismatch fixes
Message-ID: <20080413073446.GA20332@elte.hu>
References: <4800D743.3000405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4800D743.3000405@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacek Luczak <difrost.kernel@gmail.com> wrote:

> Hi,
> 
> those are patches which fixes some section mismatch stuff in 32-bit 
> part of arch/x86.

thanks Jacek, applied.

	Ingo
