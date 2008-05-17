Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYEQIc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYEQIc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 04:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYEQIcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 04:32:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51395 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYEQIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 04:32:19 -0400
Date: Sat, 17 May 2008 09:32:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] misc audit patches
Message-ID: <20080517083217.GZ13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc audit patches; please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b51

Shortlog:
Andrew Morton (1):
      [patch 1/1] audit_send_reply(): fix error-path memory leak

Paul E. McKenney (1):
      list_for_each_rcu must die: audit

Steve Grubb (1):
      open sessionid permissions

Diffstat:
 fs/proc/base.c      |    2 +-
 kernel/audit.c      |   11 ++++++-----
 kernel/audit_tree.c |    5 ++---
 3 files changed, 9 insertions(+), 9 deletions(-)

