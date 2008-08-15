Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYHOMHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYHOMHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbYHOMHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:07:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36220 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbYHOMHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:07:47 -0400
Date: Fri, 15 Aug 2008 14:07:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: arch/x86/Kconfig: clean up, experimental adjustement
Message-ID: <20080815120727.GB17751@elte.hu>
References: <20080814151650.GA23106@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814151650.GA23106@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> Adjust experimental tags in Kconfig, update config to notice that 
> i386/x86_64 is now single architecture.

thanks, applied to tip/x86/urgent. (I left out the stackprotector bit as 
that is already changed in tip/stackprotector)

	Ingo
