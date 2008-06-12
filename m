Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbYFLAWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbYFLAWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757756AbYFLAWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:22:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:50091 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbYFLAWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:22:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brigada <brigad@rpi.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] kobject: Documentation Spelling Patch
Date: Wed, 11 Jun 2008 17:21:22 -0700
Message-Id: <1213230082-13365-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <20080612001035.GA7615@suse.de>
References: <20080612001035.GA7615@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brigada <brigad@rpi.edu>

Signed-off-by: David Brigada <brigad@rpi.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kobject.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index bf3256e..51a8021 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -305,7 +305,7 @@ should not be manipulated by any other user.
 
 A kset keeps its children in a standard kernel linked list.  Kobjects point
 back to their containing kset via their kset field. In almost all cases,
-the kobjects belonging to a ket have that kset (or, strictly, its embedded
+the kobjects belonging to a kset have that kset (or, strictly, its embedded
 kobject) in their parent.
 
 As a kset contains a kobject within it, it should always be dynamically
-- 
1.5.5.3

