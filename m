Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYC1Pkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYC1Pkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYC1Pk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:40:28 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:42361 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYC1Pk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:40:27 -0400
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] doc: fix typo in SubmittingPatches
Date: Fri, 28 Mar 2008 16:40:26 +0100
Message-ID: <87r6dueu1h.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 Documentation/SubmittingPatches |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 08a1ed1..47a539c 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -512,7 +512,7 @@ They provide type safety, have no length limitations, no formatting
 limitations, and under gcc they are as cheap as macros.

 Macros should only be used for cases where a static inline is clearly
-suboptimal [there a few, isolated cases of this in fast paths],
+suboptimal [there are a few, isolated cases of this in fast paths],
 or where it is impossible to use a static inline function [such as
 string-izing].

--
1.5.5.rc1.13.g79388
