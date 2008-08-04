Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYHDKUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYHDKUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYHDKT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:19:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46044 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYHDKT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:19:56 -0400
Date: Mon, 4 Aug 2008 11:19:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit
Message-ID: <20080804101955.GV28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More oops fixes...  Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b56

Shortlog:
zhangxiliang (1):
      Re: [PATCH] Fix the kernel panic of audit_filter_task when key field is set

Diffstat:
 kernel/auditsc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
