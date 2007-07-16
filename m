Return-Path: <linux-kernel-owner+w=401wt.eu-S1763931AbXGPVvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763931AbXGPVvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXGPVvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:51:14 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:42163 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbXGPVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=WTEplTERURV3gXvkZt4QUmUEVxnjxsPvRUiytEl7/9XZHWQyoZslFS5BMiag3JO3dTjxntcr9gyxhmCIVgUmE6o8UCcgI12reefdHU0yUIxmnbFD9JB1GtthdbVVNMBWiBgFPibscSKNz6NIg8spaxpg0PZM+rOTReGFXlUNN00=
Date: Mon, 16 Jul 2007 23:51:07 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: michal.k.k.piotrowski@gmail.com
Subject: [PATCH] Add the knwon_regression URI to the documentation
Message-ID: <20070716235107.60e0c47a@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We should let everybody know about where the regression
list is hosted. The more is known the more it is used.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 Documentation/HOWTO |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 98e2701..08f4eb4 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -249,6 +249,9 @@ process is as follows:
     release a new -rc kernel every week.
   - Process continues until the kernel is considered "ready", the
     process should last around 6 weeks.
+  - A list of known regressions present in each -rc release is 
+    tracked at the following URI:
+    http://kernelnewbies.org/known_regressions 
 
 It is worth mentioning what Andrew Morton wrote on the linux-kernel
 mailing list about kernel releases:
-- 
1.5.3.rc2

