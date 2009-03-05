Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZCENvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZCENvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZCENvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:51:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbZCENvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:51:21 -0500
Date: Thu, 5 Mar 2009 14:51:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [GIT PULL] fix compiler warnings in page_types.h
Message-ID: <20090305135109.GA14196@elte.hu>
References: <49AF363E.2060405@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AF363E.2060405@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Fix some gcc 3.2.2 compiler warnings.
>
>    J
>
> The following changes since commit 4c44cf79c1ac92faa2d1268a30c3df2326812902:
>  Jeremy Fitzhardinge (1):
>        x86: un-__init fill_pud/pmd/pte
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git tip/fixups
>
> Jeremy Fitzhardinge (1):
>      x86: clean up old gcc warnings
>
> arch/x86/include/asm/page_types.h |    6 ------
> arch/x86/include/asm/pat.h        |    5 +++++
> 2 files changed, 5 insertions(+), 6 deletions(-)

Pulled into tip:x86/mm, thanks Jeremy!

	Ingo
