Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYEACxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYEACxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYEACxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:53:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51277 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbYEACxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:53:04 -0400
Date: Thu, 1 May 2008 04:52:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080501025234.GE27574@elte.hu>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430230100.GK29330@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> I would really appreciate it if you could send the error message and 
> the .config but not quick kconfig patches that are often wrong and 
> that you try to push through the maintainers as you tried here.

hey, sorry about invading your turf of trivial patches ;) I dont see it 
as a problem that the thought process and the initial patch is 
incomplete and ad-hoc. My preference is to work with people out in the 
open, even on trivial issues. Dmitry is a capable maintainer who 
understands his code very well and he'll resist me if i'm full of it. 
Just like i resisted you when you were full of it. That's what 
maintainers do, their job is to know their code.

And, occasionally, as in this case, i might end up being faced with a 
bug in the code i maintain ;)

	Ingo
