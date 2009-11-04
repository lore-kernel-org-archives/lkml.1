Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZKDSkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZKDSkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZKDSkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:40:02 -0500
Received: from [186.40.48.74] ([186.40.48.74]:40538 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753910AbZKDSkB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:40:01 -0500
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 13:39:58 EST
Subject: [PATCH] Documentation/edac
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: dougthompson@xmission.com, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Nov 2009 15:30:34 -0300
Message-ID: <1257359434.5291.5.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch fixes some typos in the Documentation/edac.txt file.

Thanks.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 Documentation/edac.txt |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 06f8f46..79c5332 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -80,7 +80,7 @@ is:
 
 	broken_parity_status
 
-as is located in /sys/devices/pci<XXX>/0000:XX:YY.Z directorys for
+as is located in /sys/devices/pci<XXX>/0000:XX:YY.Z directories for
 PCI devices.
 
 FUTURE HARDWARE SCANNING
@@ -288,9 +288,8 @@ Total UE count that had no information attribute fileY:
 
 	'ue_noinfo_count'
 
-	This attribute file displays the number of UEs that
-	have occurred have occurred with  no informations as to which DIMM
-	slot is having errors.
+	This attribute file displays the number of UEs that have occurred
+	with no information as to which DIMM slot is having errors.
 
 
 Total Correctable Errors count attribute file:

