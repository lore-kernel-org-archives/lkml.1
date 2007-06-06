Return-Path: <linux-kernel-owner+w=401wt.eu-S1765379AbXFFL4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765379AbXFFL4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762673AbXFFL4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:56:36 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:8458 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761673AbXFFL4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AEycRULu6QHyVqVHLfjcw2k9XV+VhL8hcAqKdtJqDzC5Dm8ijQjs5Hn1Ic42BzfWT7PIlQv9r1nHHnKh+q9YR6zvokddlEYHd2LuG3r1SPsBXv2G5CcJKGqmErQQ5jI5EbgvWv8iVkQW41NZumEaSV7R5UkjYgx5601lWHMcLlU=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH][Trivial] SubmitChecklist update, fix spelling error
Date: Wed, 6 Jun 2007 13:55:48 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061355.50161.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This trivial patch makes the following changes to Documentation/SubmitChecklist :

 - "sumbittal" is not a word, replace with "submission".
 - Remove a blank line, two should be enough.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Documentation/SubmitChecklist |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index 6ebffb5..19e7f65 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -1,4 +1,4 @@
-Linux Kernel patch sumbittal checklist
+Linux Kernel patch submission checklist
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Here are some basic things that developers should do if they want to see their
@@ -9,7 +9,6 @@ Documentation/SubmittingPatches and elsewhere regarding submitting Linux
 kernel patches.
 
 
-
 1: Builds cleanly with applicable or modified CONFIG options =y, =m, and
    =n.  No gcc warnings/errors, no linker warnings/errors.
 


