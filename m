Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbYGAWY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbYGAWY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYGAWYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:24:47 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:52397 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbYGAWYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:24:45 -0400
Subject: [PATCH] Update MAINTAINERS file for the TPM device driver
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: debora@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 Jul 2008 19:22:36 -0300
Message-Id: <1214950956.2381.7.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Update MAINTAINERS file for the TPM device driver.

Thanks,
Rajiv Andrade
IBM LTC Security Development

--
diff --git a/MAINTAINERS b/MAINTAINERS
index 8f0ec46..5f72839 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3995,7 +3995,8 @@ W:        http://www.buzzard.org.uk/toshiba/
 S:     Maintained

 TPM DEVICE DRIVER
-P:     Kylene Hall
+P:     Debora Velarde
+P:     Rajiv Andrade
 M:     tpmdd-devel@lists.sourceforge.net
 W:     http://tpmdd.sourceforge.net
 P:     Marcel Selhorst

