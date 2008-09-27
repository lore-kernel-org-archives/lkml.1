Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYI0QT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYI0QT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYI0QTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:19:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYI0QTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:19:18 -0400
Date: Sat, 27 Sep 2008 18:19:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Pekka Paalanen <pq@iki.fi>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 2/3] Tracing/ftrace: Adapt mmiotrace to the new
	type of print_line
Message-ID: <20080927161910.GA4600@elte.hu>
References: <48DD0347.5070008@gmail.com> <20080927002121.0038cdfe@daedalus.pq.iki.fi> <c62985530809270517g179f1d21nca05cf50b289b2f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530809270517g179f1d21nca05cf50b289b2f5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> No problem, I have one other option: ignoring and sleep again before 
> receiving another entries. I can do another patch this week end to 
> implement that. The third patch only concerns the boot tracer. It 
> relays to other output functions.
> 
> Just tell me if you agree with the ignoring...

ok, i'll defer your patchset to until there's tentative agreement from 
Pekka, as this issue affects both the mmiotrace and fastboot tracers.

	Ingo
