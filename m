Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYJUQnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYJUQnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYJUQnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:43:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36069 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYJUQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:43:06 -0400
Message-Id: <20081021164018.889518687@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 21 Oct 2008 12:40:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] ftrace: clean ups and sanity checks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Can you please pull in these two patches and run them through your tests.
I've tested them, but I know you have a more elaborate setup. Then can you send them over to Linus for 2.6.28.

These are clean ups and robustness patches. No new features here.

Thanks,

-- Steve
