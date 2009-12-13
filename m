Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZLMWnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZLMWnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZLMWnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:43:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42411 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZLMWnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:43:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/5] Async suspend/resume tree
Date: Sun, 13 Dec 2009 23:38:30 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Message-Id: <200912132338.30921.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After the async suspend/resume patches in my original pull request had been
rejected, I created an async suspend tree to save store some async-related
patches in there so that they don't get lost.  Today I rebased it on top of the
latest async suspend/resume patch posted here:
http://lkml.org/lkml/2009/12/12/124

It is on top of my linux-next tree containing the patches that I'm planning to
include in the next pull request.

At the moment, the following patches are in the async tree at:
http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=shortlog;h=refs/heads/async

Please let me know if there are objections to any of them.

Thanks,
Rafael

