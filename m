Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYIBDSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYIBDSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 23:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYIBDSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 23:18:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41883 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYIBDSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 23:18:00 -0400
Date: Tue, 2 Sep 2008 04:17:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fix breakage from readdir patches in the last merge
Message-ID: <20080902031759.GP28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for typo in hpux_getdents().  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Helge Deller (1):
      Fix typo in hpux_getdents filldir

Diffstat:
 arch/parisc/hpux/fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
