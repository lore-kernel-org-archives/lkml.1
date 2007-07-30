Return-Path: <linux-kernel-owner+w=401wt.eu-S969578AbXG3WNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969578AbXG3WNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969310AbXG3WKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:53802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969239AbXG3WKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Juan Lang <juan.lang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/11] stable_api_nonsense.txt: Disambiguate the use of "this" by using "that" to refer to the syscall interface
Date: Mon, 30 Jul 2007 15:09:29 -0700
Message-Id: <11858334013561-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11858333931362-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
 <11858333772499-git-send-email-gregkh@suse.de>
 <11858333823900-git-send-email-gregkh@suse.de>
 <11858333853388-git-send-email-gregkh@suse.de>
 <11858333892232-git-send-email-gregkh@suse.de>
 <11858333931362-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juan Lang <juan.lang@gmail.com>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/stable_api_nonsense.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/stable_api_nonsense.txt b/Documentation/stable_api_nonsense.txt
index a2afca3..847b342 100644
--- a/Documentation/stable_api_nonsense.txt
+++ b/Documentation/stable_api_nonsense.txt
@@ -10,7 +10,7 @@ kernel to userspace interfaces.  The kernel to userspace interface is
 the one that application programs use, the syscall interface.  That
 interface is _very_ stable over time, and will not break.  I have old
 programs that were built on a pre 0.9something kernel that still work
-just fine on the latest 2.6 kernel release.  This interface is the one
+just fine on the latest 2.6 kernel release.  That interface is the one
 that users and application programmers can count on being stable.
 
 
-- 
1.5.2.2

