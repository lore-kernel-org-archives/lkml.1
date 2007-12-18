Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXLRQgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXLRQgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbXLRQgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:36:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:21580 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbXLRQf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=lG+xv9aqDWjDmkSi/zXXr0pXcQR/rdPVdZX+E+IfXwuwLggx7QuHhRPNw/hVlTqmrTXZqWC7Xbro2QdFtRuX+/0Xt7lVSZHvL1kWO8I5FnsmbH6/cbW7ICmUIDpOZ2qhFkmEPTVeJSENjtYmtjcoZDxe/Y2mjP+PDSibZqq1KEw=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwlwifi: fix typo in 'drivers/net/wireless/iwlwifi/Kconfig'
Date: Tue, 18 Dec 2007 17:36:12 +0100
User-Agent: KMail/1.9.7
Cc: yi.zhu@intel.com, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712181736.13130.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo in 'drivers/net/wireless/iwlwifi/Kconfig'.

Signed-off-by: Miguel Boton <mboton@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index f495466..ca8597a 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -43,7 +43,7 @@ config IWL4965_HT
 	  for the iwl4965 driver.
 
 config IWL4965_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iw4965 driver"
+	bool "Enable Spectrum Measurement in iwl4965 driver"
 	depends on IWL4965
 	---help---
 	  This option will enable spectrum measurement for the iwl4965 driver.


-- 
	Miguel Botón
