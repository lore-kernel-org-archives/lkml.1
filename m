Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306Ab0AYRHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0AYRHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297Ab0AYRHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:07:07 -0500
Received: from smtp.nokia.com ([192.100.122.233]:54723 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0AYRHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:07:02 -0500
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 25 Jan 2010 19:05:45 +0200
Message-Id: <20100125170545.2270.32616.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.33-rc5
X-OriginalArrivalTime: 25 Jan 2010 17:05:53.0230 (UTC) FILETIME=[A6ED86E0:01CA9DE0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull 3 small UBI fixes.

The following changes since commit 74d2e4f8d79ae0c4b6ec027958d5b18058662eea:
  Linus Torvalds (1):
        Linux 2.6.33-rc3

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (2):
      UBI: add more checks to chdev open
      UBI: fix memory leak in update path

Peter Horton (1):
      UBI: initialise update marker

 drivers/mtd/ubi/kapi.c |   15 +++++++--------
 drivers/mtd/ubi/upd.c  |    1 +
 drivers/mtd/ubi/vtbl.c |    1 +
 3 files changed, 9 insertions(+), 8 deletions(-)


Thanks,
Artem.
