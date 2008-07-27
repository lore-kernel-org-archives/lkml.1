Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYG0G2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYG0G2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYG0G2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:28:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:35709 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYG0G2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=bVXVeXzU3Sm5zO+oiSzGcH+g7L7iVj5UQzRQN+fd2TQiHiVy2adHCwSJNxV4v8VaG6
         V5jtQQVsmULcVq7Y9Fjl1E3edCNNlkqAdwSJ1tA5ELDrv6NdxlMyXu4P2E6qqS0VgaMG
         jczXYOATYQEcCsWI4PtWYlq+fXOCOkCDcccjM=
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Blackfin on-chip NAND Flash Controller driver updates for 2.6.27
Date: Sun, 27 Jul 2008 14:27:52 +0800
Message-Id: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

I sent some patches of this series before. Please take a look at this whole
patch set for 2.6.27

Thanks
-Bryan
