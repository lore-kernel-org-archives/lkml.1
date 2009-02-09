Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZBIKWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZBIKWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZBIKV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:21:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZBIKV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:21:57 -0500
Date: Mon, 9 Feb 2009 11:21:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: git pull request: minor unification of pte_hidden
Message-ID: <20090209102140.GI20467@elte.hu>
References: <498CD1C8.7060800@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498CD1C8.7060800@goop.org>
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


(Cc:ed lkml)

* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The following changes since commit 072bdb8831c61e2c263151031c7d2d0b30fd7ddd:
>  Ingo Molnar (1):
>        Merge branch 'x86/mm' into kmemcheck
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git jsgf/x86/unify-kmemcheck
>
> Jeremy Fitzhardinge (2):
>      x86: make _PAGE_HIDDEN conditional
>      x86: unify pte_hidden
>
> arch/x86/include/asm/pgtable.h    |   12 +++++++++++-
> arch/x86/include/asm/pgtable_32.h |    6 ------
> arch/x86/include/asm/pgtable_64.h |    6 ------
> 3 files changed, 11 insertions(+), 13 deletions(-)

Pulled into tip/kmemcheck, thanks Jeremy!

	Ingo
