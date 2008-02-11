Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbYBKRNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbYBKRNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYBKRNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:13:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYBKRNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:13:43 -0500
Date: Mon, 11 Feb 2008 18:13:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: cavokz@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v7
Message-ID: <20080211171331.GA14523@elte.hu>
References: <20080210222025.GA6646@elte.hu> <20080211154133.GA3292@ska.dandreoli.com> <47B07DEB.3090803@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B07DEB.3090803@siemens.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jan Kiszka <jan.kiszka@siemens.com> wrote:

> Domenico Andreoli wrote:
> > On Sun, Feb 10, 2008 at 11:20:26PM +0100, Ingo Molnar wrote:
> >> this is -v7 of the KGDB-light tree, which can be pulled from:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git
> > 
> > my git hangs on this..
> 
> Just booting? Or using the debugger? If the former: does switching 
> KGDB off in the config solve it?

heh - i suspect what he meant is that his user-space git pull/clone is 
hanging on that repository :)

transient failures sometimes happen - the cloning should be re-tried.

	Ingo
