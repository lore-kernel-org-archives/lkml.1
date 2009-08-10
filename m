Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZHJWxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZHJWxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZHJWxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:53:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZHJWw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:52:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fix for 2.6.31
Date: Tue, 11 Aug 2009 00:53:24 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908110053.24678.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a power management fix for 2.6.31 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

It removes a run-time warning in drivers/base/platform.c that
was added prematurely.

 drivers/base/platform.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

---------------

Magnus Damm (1):
      PM / Driver Core: Kill dev_pm_ops platform warning for now

