Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZDFM5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZDFM5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZDFM5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:57:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44893 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbZDFM5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:57:02 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] LANANA: Fix dates
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 14:55:50 +0100
Message-ID: <20090406135444.17202.37417.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noted by Janne Grunau it would be good if the date was also right.

(Web site also resynched)

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 Documentation/devices.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 327de16..4d70df6 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -3,7 +3,7 @@
 
 	     Maintained by Alan Cox <device@lanana.org>
 
-		      Last revised: 29 November 2006
+		      Last revised: 6th April 2009
 
 This list is the Linux Device List, the official registry of allocated
 device numbers and /dev directory nodes for the Linux operating

