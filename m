Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYKUH6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYKUH6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYKUH54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:57:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYKUH5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:57:55 -0500
Date: Fri, 21 Nov 2008 08:57:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: update comment for move_task_off_dead_cpu
Message-ID: <20081121075735.GD16242@elte.hu>
References: <20081121003036.GA8124@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121003036.GA8124@localhost.localdomain>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Subject: [PATCH] sched: update comment for move_task_off_dead_cpu

applied to tip/sched/core, thanks Vegard!

> Feel free to shorten the log message if this is in excess for the 
> removal of a single line... I just wanted to provide the context for 
> the change.
> 
> :-)

in fact i added another line as well:

  Impact: cleanup

:-)

	Ingo
