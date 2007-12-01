Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXLAX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXLAX5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 18:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbXLAX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 18:57:23 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:3189 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbXLAX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 18:57:22 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH] cxgb - revert file mode changes.
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Dec 2007 15:57:17 -0800
Message-ID: <20071201235717.22418.24800.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

revert inavertant file mode changes

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/chelsio/cxgb2.c  |    0 
 drivers/net/chelsio/pm3393.c |    0 
 drivers/net/chelsio/sge.c    |    0 
 drivers/net/chelsio/sge.h    |    0 
 4 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/drivers/net/chelsio/cxgb2.c b/drivers/net/chelsio/cxgb2.c
old mode 100755
new mode 100644
diff --git a/drivers/net/chelsio/pm3393.c b/drivers/net/chelsio/pm3393.c
old mode 100755
new mode 100644
diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
old mode 100755
new mode 100644
diff --git a/drivers/net/chelsio/sge.h b/drivers/net/chelsio/sge.h
old mode 100755
new mode 100644
