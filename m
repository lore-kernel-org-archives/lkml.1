Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab0BQAdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:33:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:35707 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933612Ab0BQAdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:33:12 -0500
From: Konrad Rzeszutek Wilk <kliw@darnok.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] IBFT patches for 2.6.33-rc8
Date: Wed, 17 Feb 2010 00:33:02 +0000
Message-Id: <1266366783-851-1-git-send-email-kliw@darnok.org>
X-Mailer: git-send-email 1.7.0
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 00:33:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a IBFT patch for 2.6.33-rc8.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/ibft-2.6.git/

The patch has been in the mm-tree.

-----

 drivers/firmware/iscsi_ibft.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

