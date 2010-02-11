Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0BKVc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:32:59 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:53809 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab0BKVc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:32:56 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
       "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Thread-Topic: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Thread-Index: AQHKq2HFt5YrdyjaOk+txGcH5EzUMw==
Date: Thu, 11 Feb 2010 21:32:31 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56212E88291@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56212E881A9@TK5EX14MBXC118.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed two line;
	Audit block driver
	Audit scsi driver
They were added by us as part of the original code
Submission to make sure these drivers kept on working
Correctly with all the patches that came in from the 
Community. 

Added a new line to fix mostly insane camelcase naming
We are working on that right now, but it will take a bit
Due to the pervasive usage of it.

Cc: Greg Kroah-Hartman         <gregkh@suse.de>
Signed-off-by: Hank Janssen    <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang   <haiyang@microsoft.com>


drivers/staging/hv/TODO |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO
index dbfbde9..e0bc3c8 100644
--- a/drivers/staging/hv/TODO
+++ b/drivers/staging/hv/TODO
@@ -12,8 +12,7 @@ TODO:
 	  - use existing net_device_stats struct in network device
 	  - checking for carrier inside open is wrong, network device API
             confusion??
-	- audit the block driver
-	- audit the scsi driver
+	- Fix CamelCase naming conventions
 
 Please send patches for this code to Greg Kroah-Hartman <gregkh@suse.de>,
 Hank Janssen <hjanssen@microsoft.com>, and Haiyang Zhang <haiyangz@microsoft.com>.

