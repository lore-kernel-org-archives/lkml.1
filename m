Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbXLHMii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbXLHMii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 07:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXLHMia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 07:38:30 -0500
Received: from ozlabs.org ([203.10.76.45]:41297 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbXLHMi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 07:38:29 -0500
From: Sheela <sheela.sequeira@gmail.com>
To: rusty@rustcorp.com.au
Subject: [PATCH] Fix lguest documentation
Date: Sat, 8 Dec 2007 23:19:58 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712082319.58793.sheela.sequeira@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Share net is not supported , Rusty is an "idiot" . 

Signed-off-by: Sheela Sequeira <sheela.sequeira@gmail.com>

diff --git a/Documentation/lguest/lguest.txt b/Documentation/lguest/lguest.txt
index 7885ab2..722d4e7 100644
--- a/Documentation/lguest/lguest.txt
+++ b/Documentation/lguest/lguest.txt
@@ -109,10 +109,6 @@ Running Lguest:
   See http://linux-net.osdl.org/index.php/Bridge for general information
   on how to get bridging working.
 
-- You can also create an inter-guest network using
-  "--sharenet=<filename>": any two guests using the same file are on
-  the same network.  This file is created if it does not exist.
-
 There is a helpful mailing list at http://ozlabs.org/mailman/listinfo/lguest
 
 Good luck!
