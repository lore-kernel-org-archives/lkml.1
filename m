Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZIJUt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZIJUt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZIJUt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:49:56 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:11852 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZIJUt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:49:56 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tom Hanrahan" <hanrahat@microsoft.com>
Subject: [patch] Staging: hv: Add new tasks to the TODO file
Thread-Topic: [patch] Staging: hv: Add new tasks to the TODO file
Thread-Index: AcoyWEDkXkMdXuS/TzW/xG2oNhanAw==
Date: Thu, 10 Sep 2009 20:49:56 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF720B8E1E77@TK5EX14MBXC130.redmond.corp.microsoft.com>
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

From: Haiyang Zhang <haiyangz@microsoft.com>

Add new tasks to the TODO file.

Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO
index fc754ab..345a59f 100644
--- a/drivers/staging/hv/TODO
+++ b/drivers/staging/hv/TODO
@@ -11,6 +11,12 @@ TODO:
        - audit the network driver
        - audit the block driver
        - audit the scsi driver
+       - SMP Support
+       - Remote Shutdown
+       - Networking . Jumbo Frames
+       - Hot swappable storage devices
+       - Time Synchronization
+       - Key Value Pair Exchange

 Please send patches for this code to Greg Kroah-Hartman <gregkh@suse.de>,
 Hank Janssen <hjanssen@microsoft.com>, and Haiyang Zhang <haiyangz@microsoft.com>.

