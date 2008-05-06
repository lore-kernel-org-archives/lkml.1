Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbYEFCeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbYEFCeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbYEFCeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:34:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758198AbYEFCeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:34:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] posix timers: timer_delete: remove the bogus "->it_process != NULL" check
In-Reply-To: Oleg Nesterov's message of  Saturday, 3 May 2008 21:35:53 +0400 <20080503173553.GA8109@tv-sign.ru>
References: <20080503173553.GA8109@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080506023342.4076F26FA20@magilla.localdomain>
Date: Mon,  5 May 2008 19:33:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roland McGrath <roland@redhat.com>
