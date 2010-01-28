Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001Ab0A1M0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0A1M0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605Ab0A1M0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:26:17 -0500
Received: from smtp.nokia.com ([192.100.122.233]:22296 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab0A1M0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:26:16 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 28 Jan 2010 14:25:55 +0200
Message-Id: <20100128122555.22117.22463.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.33-rc6
X-OriginalArrivalTime: 28 Jan 2010 12:26:06.0340 (UTC) FILETIME=[1066A440:01CAA015]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull one more UBI bugfix. Sorry for sending you 2 pull requests during
one week, but this fix is just a very important one.

The following changes since commit 92dcffb916d309aa01778bf8963a6932e4014d07:
  Linus Torvalds (1):
        Linux 2.6.33-rc5

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git for-linus

Mika Westerberg (1):
      UBI: fix volume creation input checking

 drivers/mtd/ubi/cdev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

Thanks,
Artem.
