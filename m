Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZIXAl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZIXAl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbZIXAlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:41:52 -0400
Received: from hq-exedge.brocade.com ([66.243.153.82]:30947 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZIXAlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:41:49 -0400
Date: Wed, 23 Sep 2009 17:41:52 -0700
From: Jing Huang <huangj@brocade.com>
Message-ID: <200909240041.n8O0fq0j019952@blc-10-6.brocade.com>
To: <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/14] bfa: Brocade BFA FC SCSI driver (overview)
CC: <kgudipat@brocade.com>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <rvadivel@brocade.com>,
       <vravindr@brocade.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

Incorporated code review comments from Andrew Morton and Brian King. Please
consider this patch set for next kernel update.

Patches are generated and tested in 2.6.31 kernel.

[PATCH 1/14]: SCSI LLD driver code, module init/exit, PCI and SCSI host entry
points, interrupt handler, and sysfs interface etc. 

[PATCH 2/14]: Hardware/FW access code. part-1

[PATCH 3/14]: Hardware/FW access code. part-2

[PATCH 4/14]: Hardware/FW access code. part-3

[PATCH 5/14]: Hardware/FW access code. part-4

[PATCH 6/14]: FC state machines. part-1

[PATCH 7/14]: FC state machines. part-2

[PATCH 8/14]: FC state machines. part-3

[PATCH 9/14]: FC state machines. part-3

[PATCH 10/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-1

[PATCH 11/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-2

[PATCH 12/14]: Common header files shared by linux driver,
hardware/FW access code, FC state machines. part-3

[PATCH 13/14]: Updated Kconfig and Makefile for driver/scsi, and Makefile
for bfa driver 

[PATCH 14/14]: Updated MAINTAINER file.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
