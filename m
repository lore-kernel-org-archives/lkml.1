Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbYA2AE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbYA2AE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYA2AEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:04:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57456 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYA2AEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:04:49 -0500
Date: Mon, 28 Jan 2008 17:04:47 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, Liam Howlett <howlett@gmail.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Pull request: TASK_KILLABLE
Message-ID: <20080129000447.GC31101@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I'd like you to pull the task_killable branch of
git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git

All the patches have been posted to linux-kernel before, and various
comments (and acks) have been taken into account.

Andrew's had the first fifteen patches (up to, and including 'Use
lock_page_killable') in his tree for a few months.  There's a lot more
work pending, but it's all incremental improvements.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
