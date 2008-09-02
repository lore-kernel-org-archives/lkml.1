Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYIBDM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYIBDM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 23:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYIBDMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 23:12:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40117 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYIBDMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 23:12:18 -0400
Date: Tue, 2 Sep 2008 04:12:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit fix
Message-ID: <20080902031217.GO28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b57

Shortlog:
Cordelia (1):
      audit: Moved variable declaration to beginning of function

Diffstat:
 kernel/auditsc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

