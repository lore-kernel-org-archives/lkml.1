Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbXISUIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbXISUIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXISUIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:08:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:63279 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXISUIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tTYm2juVEPVs/PZOcbJ4onImE8OGM/qiG9MQ6+K8Ilvty3BlVcH6HWgJaREzawHUjLqvm1ASjpi76v/Oc2U/5y6zR8+6zFY6a2KatO3Kqhd3S0e7WtQIlkBu8zwXv3DLdTnfqwTG9poinJ3BGORpT3KcWb45cm5zpkkqIoW3mSE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: mark ide-scsi as Orphan
Date: Wed, 19 Sep 2007 22:08:56 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709192208.57023.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1889,6 +1889,11 @@ M:	Gadi Oxman <gadio@netvision.net.il>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+IDE-SCSI DRIVER
+L:	linux-ide@vger.kernel.org
+L:	linux-scsi@vger.kernel.org
+S:	Orphan
+
 IEEE 1394 SUBSYSTEM
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
