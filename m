Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYFYDm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYFYDm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYFYDmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:42:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42749 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYFYDmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:42:17 -0400
Date: Wed, 25 Jun 2008 04:42:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit fixes
Message-ID: <20080625034216.GD28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Final audit bits for .26.  Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b52

Diffstat:
 include/linux/audit.h |    2 +-
 kernel/audit.c        |    6 +++---
 kernel/auditfilter.c  |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

Shortlog:

Peng Haitao (2):
      kernel/audit.c: nlh->nlmsg_type is gotten more than once
      remove useless argument type in audit_filter_user()

Randy Dunlap (1):
      audit: fix kernel-doc parameter notation
