Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYGVFWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYGVFWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYGVFVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:21:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:43018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbYGVFVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:21:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/79] debugfs: Add a reference to the debugfs API documentation.
Date: Mon, 21 Jul 2008 22:18:27 -0700
Message-Id: <1216703983-21448-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/Kconfig.debug |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index df27132..ba106db 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -74,6 +74,9 @@ config DEBUG_FS
 	  debugging files into.  Enable this option to be able to read and
 	  write to these files.
 
+	  For detailed documentation on the debugfs API, see
+	  Documentation/DocBook/filesystems.
+
 	  If unsure, say N.
 
 config HEADERS_CHECK
-- 
1.5.6.3

