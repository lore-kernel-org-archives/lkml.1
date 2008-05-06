Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYEFMkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYEFMkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYEFMkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:40:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38785 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbYEFMkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:40:22 -0400
Date: Tue, 6 May 2008 14:40:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: process fam 10h like k8 with fixed mtrr setting
Message-ID: <20080506124003.GQ32591@elte.hu>
References: <200805051557.38556.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805051557.38556.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0718]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> otherwise fixed MTRR for family 10h may not be changed

applied, thanks.

	Ingo
