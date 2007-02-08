Return-Path: <linux-kernel-owner+w=401wt.eu-S1161506AbXBHAdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161506AbXBHAdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161497AbXBHAdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:34080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422896AbXBHAcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:41 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/28] HOWTO: Add a reference to Harbison and Steele
Date: Wed,  7 Feb 2007 16:30:10 -0800
Message-Id: <11708946932742-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946903974-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com> <11708946832214-git-send-email-greg@kroah.com> <11708946871208-git-send-email-greg@kroah.com> <1170894
 6903974-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@mindspring.com>

Add a reference to Harbison and Steele's C book.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/HOWTO |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 8d51c14..48123db 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -30,6 +30,7 @@ are not a good substitute for a solid C education and/or years of
 experience, the following books are good for, if anything, reference:
  - "The C Programming Language" by Kernighan and Ritchie [Prentice Hall]
  - "Practical C Programming" by Steve Oualline [O'Reilly]
+ - "C:  A Reference Manual" by Harbison and Steele [Prentice Hall]
 
 The kernel is written using GNU C and the GNU toolchain.  While it
 adheres to the ISO C89 standard, it uses a number of extensions that are
-- 
1.4.4.4

