Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZGUKc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZGUKc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZGUKc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:32:57 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47744 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZGUKc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:32:56 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 21 Jul 2009 15:23:44 +0300
Message-Id: <20090721122344.6590.13210.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.31-rc4
X-OriginalArrivalTime: 21 Jul 2009 10:32:08.0683 (UTC) FILETIME=[7FF0BBB0:01CA09EE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are two UBI bugfixes - a minor one and a major one of
"brown paperbag" type. Please, pull form:

git://git.infradead.org/ubi-2.6.git linux-next

The following changes since commit 6847e154e3cd74fca6084124c097980a7634285a:
  Linus Torvalds (1):
        Linux 2.6.31-rc3

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (1):
      UBI: gluebi: initialize ubi_num field

Holger Brunck (1):
      UBI: fix bug in image sequence number handling

 drivers/mtd/ubi/gluebi.c |    1 +
 drivers/mtd/ubi/scan.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

Thanks,
Artem.
