Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYGWQtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYGWQtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYGWQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:48:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49529 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbYGWQsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:48:47 -0400
Date: Wed, 23 Jul 2008 20:52:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark McLoughlin <markmc@redhat.com>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 0/2] posix-timers: fixes
Message-ID: <20080723165204.GA4289@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, I failed to trigger the race with your testcase, could you check
if the patch makes a difference? It "obviously" should, but still.

As suggested, I'm ccing stable@, but I'd strongly recommend to wait for
the maintainer's review ;)

Oleg.

