Return-Path: <linux-kernel-owner+w=401wt.eu-S1761163AbZCPHd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163AbZCPHd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759838AbZCPHdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:33:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761217AbZCPHdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:33:41 -0400
Date: Mon, 16 Mar 2009 08:33:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paulo Cezar A Junior <pcacjr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtrr: cleanup and set conding style
Message-ID: <20090316073335.GB14659@elte.hu>
References: <200903152128.28663.pcacjr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903152128.28663.pcacjr@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paulo Cezar A Junior <pcacjr@gmail.com> wrote:

> I mean there are lots of things to clean up in MTRR code, 
> considering to its coding style as well.
> 
> Signed-off-by: Paulo Cezar A Junior <pcacjr@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c

When doing cleanups of x86 architecture code please work against 
the latest x86 development tree:

  http://people.redhat.com/mingo/tip.git/README

Your patch does not apply against it:

  30 out of 47 hunks FAILED -- rejects in file arch/x86/kernel/cpu/mtrr/main.c

	Ingo
