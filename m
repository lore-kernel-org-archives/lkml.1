Return-Path: <linux-kernel-owner+w=401wt.eu-S1763888AbZFKXC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763888AbZFKXC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762167AbZFKXCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:02:18 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:47057 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760936AbZFKXCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:02:18 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH] trivial: remove the trivial patch monkey's name from SubmittingPatches
Date: Fri, 12 Jun 2009 01:02:34 +0200
Message-Id: <1244761355-1099-1-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.2.236.ge505d
X-Provags-ID: V01U2FsdGVkX19DYylorDeBnR+RTZ0Cajj02RgrqEWazSymuPBc
	sZB6rcxHwrpJcidfXkAapONNqqe6z3G09i4tjB1HmQPGzrWNqA
	B4GFgwhkBSSi9Ugaf8fg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is outdated here and can be found in the MAINTAINERS file. Also
remove the URL of the previous maintainer, similar content can be found
in the SubmittingPatches file.

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 Documentation/SubmittingPatches |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index f309d3c..9534311 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -183,8 +183,9 @@ Even if the maintainer did not respond in step #4, make sure to ALWAYS
 copy the maintainer when you change their code.
 
 For small patches you may want to CC the Trivial Patch Monkey
-trivial@kernel.org managed by Jesper Juhl; which collects "trivial"
-patches. Trivial patches must qualify for one of the following rules:
+trivial@kernel.org which collects "trivial" patches. Have a look
+into the MAINTAINERS file for its current manager.
+Trivial patches must qualify for one of the following rules:
  Spelling fixes in documentation
  Spelling fixes which could break grep(1)
  Warning fixes (cluttering with useless warnings is bad)
@@ -196,7 +197,6 @@ patches. Trivial patches must qualify for one of the following rules:
  since people copy, as long as it's trivial)
  Any fix by the author/maintainer of the file (ie. patch monkey
  in re-transmission mode)
-URL: <http://www.kernel.org/pub/linux/kernel/people/juhl/trivial/>
 
 
 
-- 
1.6.3.2.236.ge505d

