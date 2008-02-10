Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYBJDVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYBJDVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 22:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbYBJDVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 22:21:05 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:57501 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755560AbYBJDVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 22:21:04 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Update kernel/.gitignore with new generated files
Cc: mingo@elte.hu, torvalds@linux-foundation.org, tglx@linutronix.de
Content-Disposition: inline
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Date: Sun, 10 Feb 2008 05:19:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200802100519.06720.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch updates kernel/.gitignore with new auto-generated files

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 kernel/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/.gitignore b/kernel/.gitignore
index f2ab700..ab4f109 100644
--- a/kernel/.gitignore
+++ b/kernel/.gitignore
@@ -3,3 +3,4 @@
 #
 config_data.h
 config_data.gz
+timeconst.h

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
