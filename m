Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYBQPu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYBQPu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYBQPuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:50:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYBQPuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:50:13 -0500
Date: Sun, 17 Feb 2008 16:50:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: coding style fixes
	arch/x86/lib/csum-wrappers_64.c
Message-ID: <20080217155000.GC22132@elte.hu>
References: <20080217145728.46ecdaa5@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217145728.46ecdaa5@paolo-desktop>
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


* Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:

> [PATCH 2/2] x86: coding style fixes arch/x86/lib/csum-wrappers_64.c
> 
> On top of the previous patch makes the file errors free according to 
> checkpatch.pl

thanks Paolo, applied. (i've folded the two patches - as long as a 
cleanup patch has no effect on generated code we want to deal with it in 
a single unit)

	Ingo
