Return-Path: <linux-kernel-owner+w=401wt.eu-S1762965AbYDYQ15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762965AbYDYQ15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759366AbYDYQ1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:27:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44000 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759319AbYDYQ1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:27:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 25 Apr 2008 18:26:32 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.13caca57c4b06678@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394 subsystem updates.

Pieter Palmers (1):
      ieee1394: rawiso: requeue packet for transmission after skipped cycle

Tony Breeds (1):
      ieee1394: silence defined but not used warning in non-modular builds

 drivers/ieee1394/dv1394.c    |    2 ++
 drivers/ieee1394/iso.h       |    2 ++
 drivers/ieee1394/ohci1394.c  |   34 ++++++++++++++++++++++++++++++++++
 drivers/ieee1394/raw1394.c   |    9 ++++++++-
 drivers/ieee1394/video1394.c |    2 ++
 5 files changed, 48 insertions(+), 1 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--- -=-- ==--=
http://arcgraph.de/sr/

