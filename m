Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZHTGyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZHTGyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 02:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZHTGyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 02:54:43 -0400
Received: from gate07out.mcdata.com ([144.49.194.4]:23239 "EHLO
	mx30.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZHTGym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 02:54:42 -0400
X-IronPort-AV: E=Sophos;i="4.43,413,1246863600"; 
   d="scan'208";a="89432406"
Date: Wed, 19 Aug 2009 23:54:43 -0700
From: Jing Huang <huangj@brocade.com>
Message-Id: <200908200654.n7K6shpn005971@swe57.brocade.com>
To: James.Bottomley@HansenPartnership.com
Subject: [PATCH 0/14] bfa: Brocade BFA FC SCSI driver (overview)
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rvadivel@brocade.com, vravindr@brocade.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

Resubmitting the patches after implemented some of the code review comments
from Sam Ravnborg. Patches are generated using 2.6.31-rc6 kernel.

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
