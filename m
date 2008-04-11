Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbYDKLnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbYDKLnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbYDKLnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:43:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40496 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbYDKLnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:43:15 -0400
Date: Fri, 11 Apr 2008 13:42:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       linux-next@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: Section mismatch fixes
Message-ID: <20080411114258.GF9205@elte.hu>
References: <47FF4B54.50402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FF4B54.50402@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0027]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacek Luczak <difrost.kernel@gmail.com> wrote:

> those patches fixes some section mismatch warnings, which appear on 
> x86_64 with linux-next-200804[09,10,11].

> It's continuation of work on section mismatches which result in two 
> patches send previously:
>
> 	- http://lkml.org/lkml/2008/4/10/88
> 	- http://lkml.org/lkml/2008/4/10/290
> 
> Patches are against x86/latest.

thanks, applied.

(one sidenote: please do not use the same subject line for all patches, 
that makes it harder to auto-generate patch names and makes the shortlog 
harder to read as well.)

	Ingo
