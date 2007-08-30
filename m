Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbXH3XAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbXH3XAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 19:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbXH3W74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:59:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:50852 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbXH3W7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:59:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,327,1183359600"; 
   d="scan'208";a="286234813"
From: Jason Gaston <jason.d.gaston@intel.com>
To: khali@linux-fr.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       jason.d.gaston@intel.com, i2c@lm-sensors.org
Subject: [PATCH 2.6.23-rc4] i2c-i801: Documentation patch for Intel Tolapai
Date: Thu, 30 Aug 2007 16:02:05 -0700
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708301602.05849.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Tolapai SMBus Controller text to i2c-i801 
documentation.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.23-rc4/Documentation/i2c/busses/i2c-i801.orig	2007-08-30 
15:56:39.000000000 -0700
+++ linux-2.6.23-rc4/Documentation/i2c/busses/i2c-i801	2007-08-30 
15:57:32.000000000 -0700
@@ -13,7 +13,8 @@
   * Intel 631xESB/632xESB (ESB2)
   * Intel 82801H (ICH8)
   * Intel ICH9
-    Datasheets: Publicly available at the Intel website
+  * Intel Tolapai
+   Datasheets: Publicly available at the Intel website
 
 Authors: 
 	Frodo Looijaard <frodol@dds.nl>, 
