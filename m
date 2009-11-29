Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbZK2Stb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbZK2Stb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 13:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZK2Sta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 13:49:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36913 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZK2Sta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 13:49:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fix for 2.6.32
Date: Sun, 29 Nov 2009 19:49:49 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911291949.49250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a power management fix for 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

This includes one change fixing irq enable/disable in runtime PM code.


 drivers/base/power/runtime.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

---------------

Alan Stern (1):
      PM: fix irq enable/disable in runtime PM code

