Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYKUMsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYKUMsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYKUMsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:48:20 -0500
Received: from smtp.nokia.com ([192.100.105.134]:25167 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYKUMsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:48:19 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 21 Nov 2008 16:23:17 +0200
Message-Id: <20081121142317.4697.69123.sendpatchset@gollum>
Subject: [GIT PULL] UBI updates for 2.6.28-rc6
X-OriginalArrivalTime: 21 Nov 2008 12:47:51.0631 (UTC) FILETIME=[5D8C7DF0:01C94BD7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

git://git.infradead.org/~dedekind/ubi-2.6.git linux-next

to receive the following UBI fixes:

Vitaliy Gusev (1):
      UBI: Don't exit from ubi_thread until kthread_should_stop() is true

Zoltan Sogor (1):
      UBI: fix EBADMSG handling

 drivers/mtd/ubi/eba.c  |    2 +-
 drivers/mtd/ubi/scan.c |    2 +-
 drivers/mtd/ubi/wl.c   |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

Thanks.
