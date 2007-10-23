Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbXJWJ7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbXJWJ7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXJWJ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:59:12 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47889
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751993AbXJWJ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:59:11 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Add chapter IDs to z8530book.tmpl
Date: Tue, 23 Oct 2007 04:58:38 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, alan@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230458.38440.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add chapter IDs to z8530book.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/DocBook/z8530book.tmpl |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -r 33c949e2f851 Documentation/DocBook/z8530book.tmpl
--- a/Documentation/DocBook/z8530book.tmpl	Sun Oct 21 13:37:07 2007 -0400
+++ b/Documentation/DocBook/z8530book.tmpl	Mon Oct 22 23:19:42 2007 -0500
@@ -77,7 +77,7 @@
   </para>
   </chapter>
   
-  <chapter>
+  <chapter id="Driver_Modes">
  	<title>Driver Modes</title>
   <para>
 	The Z85230 driver layer can drive Z8530, Z85C30 and Z85230 devices
@@ -108,7 +108,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Using_the_Z85230_driver">
  	<title>Using the Z85230 driver</title>
   <para>
 	The Z85230 driver provides the back end interface to your board. To
@@ -174,7 +174,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Attaching_Network_Interfaces">
  	<title>Attaching Network Interfaces</title>
   <para>
 	If you wish to use the network interface facilities of the driver,
@@ -216,7 +216,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Configuring_And_Activating_The_Port">
  	<title>Configuring And Activating The Port</title>
   <para>
 	The Z85230 driver provides helper functions and tables to load the
@@ -300,7 +300,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Network_Layer_Functions">
  	<title>Network Layer Functions</title>
   <para>
 	The Z8530 layer provides functions to queue packets for
@@ -327,7 +327,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Porting_The_Z8530_Driver">
      <title>Porting The Z8530 Driver</title>
   <para>
 	The Z8530 driver is written to be portable. In DMA mode it makes

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
