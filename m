Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYAFJbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYAFJbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYAFJb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:31:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYAFJb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:31:29 -0500
Date: Sun, 6 Jan 2008 10:31:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86: paravirt_patch_{32|64}.c unification
Message-ID: <20080106093117.GA26291@elte.hu>
References: <200801060105.44758.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801060105.44758.mboton@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miguel Botón <mboton.lkml@gmail.com> wrote:

> paravirt_patch_{32|64}.c unification.
> 
> This patch unifies the code from the paravirt_patcht_32.c and 
> paravirt_patch_64.c files.
> 
> I couldn't test this modification but it shouldn't have any bugs (it's 
> a very simple modification).

thanks, applied. Will let you know if it fails anywhere.

	Ingo
