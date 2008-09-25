Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYIYENA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYIYENA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYIYEMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:12:50 -0400
Received: from mx30.brocade.com ([144.49.194.4]:48579 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYIYEMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:12:49 -0400
X-IronPort-AV: E=Sophos;i="4.33,305,1220252400"; 
   d="scan'208";a="48025552"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 6/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 21:12:24 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F27D25@HQ-EXCH-5.corp.brocade.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 6/6] bfa: Brocade BFA FC SCSI Driver submission
Thread-Index: AckexOolYSTQSDDWQjmuyVL6dU6BRA==
From: "Jing Huang" <huangj@Brocade.COM>
To: <James.Bottomley@HansenPartnership.com>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Ramkumar Vadivelu" <rvadivel@Brocade.COM>,
       "Vinodh Ravindran" <vravindr@Brocade.COM>,
       "Srikanth Rayas (CW)" <srayas@Brocade.COM>
X-OriginalArrivalTime: 25 Sep 2008 04:12:48.0974 (UTC) FILETIME=[F8957EE0:01C91EC4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains updated MAINTAINERS file. It is created using
2.6.27-rc7 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2008-09-24 13:40:12.000000000 -0700
+++ patch/MAINTAINERS	2008-09-24 13:44:25.000000000 -0700
@@ -995,6 +995,12 @@ M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+BROCADE BFA FC SCSI DRIVER
+P:	Jing Huang 
+M:	huangj@brocade.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
