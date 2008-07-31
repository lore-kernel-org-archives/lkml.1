Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYGaQXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYGaQXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYGaQXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:23:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYGaQXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:23:02 -0400
Date: Thu, 31 Jul 2008 18:21:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 0/6] x86: coding style fixes to arch/x86/kernel/
Message-ID: <20080731162155.GC26393@elte.hu>
References: <gustavo@las.ic.unicamp.br> <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.8 required=5.9 tests=BAYES_05,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0421]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: checkpatch.pl]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gustavo F. Padovan <gustavo@las.ic.unicamp.br> wrote:

> Ingo,
> 
> I removed all errors and many warnings reported by checkpatch.pl for 
> five files into arch/x86/kernel. I used a Linus tree with this HEAD: 
> 63add2f2072e69c1eb7a5f6ca8f415122da889b9 which was commited seven 
> hours ago.

applied to tip/x86/cleanups - thanks Gustavo.

	Ingo
