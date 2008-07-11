Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYGKBAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYGKBAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbYGKA7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] ftrace: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Working on the ftrace.txt file proved to show some bugs with ftrace.
These are a list of patches that I have accumulated for ftrace that solve
those bugs (as well as other things).

-- Steve

