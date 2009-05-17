Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZEQKDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZEQKDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZEQKC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:02:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46170 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZEQKCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:02:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM update for 2.6.30
Date: Sun, 17 May 2009 12:01:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171202.00103.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a power management update for 2.6.30 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

This fixes an obvious mistake in the core hibernation code.

 kernel/power/disk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

---------------

Bjorn Helgaas (1):
      PM: check sysdev_suspend(PMSG_FREEZE) return value


Thanks,
Rafael

