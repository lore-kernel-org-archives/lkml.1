Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbXFSJXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbXFSJXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXFSJXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:23:46 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:55430 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXFSJXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:23:46 -0400
Date: Tue, 19 Jun 2007 18:22:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh64 fixes
Message-ID: <20070619092211.GD23697@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh64-2.6.git

Which contains:

Paul Mundt (1):
      sh64: Handle -ERESTART_RESTARTBLOCK for restartable syscalls.

 arch/sh64/kernel/signal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
