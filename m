Return-Path: <linux-kernel-owner+w=401wt.eu-S1751765AbZJXRjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbZJXRjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 13:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZJXRjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 13:39:09 -0400
Received: from smtp.nokia.com ([192.100.105.134]:56903 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZJXRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 13:39:08 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 24 Oct 2009 20:37:11 +0300
Message-Id: <20091024173711.22285.41111.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI fixes for 2.6.32-rc6
X-OriginalArrivalTime: 24 Oct 2009 17:39:08.0017 (UTC) FILETIME=[E37F1E10:01CA54D0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull two UBI fixes for 2.6.32-rc6.

The following changes since commit 012abeea669ea49636cf952d13298bb68654146a:
  Linus Torvalds (1):
        Linux 2.6.32-rc5

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git for-linus

Artem Bityutskiy (1):
      UBI: fix backward compatibility

Roel Kluin (1):
      UBI: fix check on unsigned long

 drivers/mtd/ubi/build.c |    3 ++-
 drivers/mtd/ubi/scan.c  |    7 +++----
 drivers/mtd/ubi/scan.h  |    2 --
 3 files changed, 5 insertions(+), 7 deletions(-)

Thanks,
Artem.
