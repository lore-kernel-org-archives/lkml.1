Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZCaL0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZCaL0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbZCaLZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:25:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:51746 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbZCaLZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:25:44 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 14:24:33 +0300
Message-Id: <20090331112433.5336.57738.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.30
X-OriginalArrivalTime: 31 Mar 2009 11:24:35.0510 (UTC) FILETIME=[45546D60:01C9B1F3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBI changes.

The following changes since commit d2f8d7ee1a9b4650b4e43325b321801264f7c37a:
  Linus Torvalds (1):
        Linux 2.6.29-rc5

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git linux-next

Corentin Chary (1):
      UBI: add fsync capability

 drivers/mtd/ubi/cdev.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

Thanks,
Artem.
