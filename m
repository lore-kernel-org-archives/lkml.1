Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZFDO07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZFDO07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZFDO0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:26:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38431 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZFDO0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:26:51 -0400
Date: Thu, 4 Jun 2009 16:26:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trivial patch monkey <trivial@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: SubmittingPatches: fix typo
Message-ID: <20090604142650.GA29615@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix typo.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
commit f561456a19a7fd16cccd81084e6fa00070f36a6f
tree 89a93fd0ab436001347aac2b1c505c65c8dcdc55
parent 7fc5b2aaf21b1b3c3db361e22d9b0fa1d4d845ef
author Pavel <pavel@ucw.cz> Thu, 04 Jun 2009 16:26:20 +0200
committer Pavel <pavel@ucw.cz> Thu, 04 Jun 2009 16:26:20 +0200

 Documentation/SubmittingPatches |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index f309d3c..c282380 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -444,7 +444,7 @@ offer a Reviewed-by tag for a patch.  This tag serves to give credit to
 reviewers and to inform maintainers of the degree of review which has been
 done on the patch.  Reviewed-by: tags, when supplied by reviewers known to
 understand the subject area and to perform thorough reviews, will normally
-increase the liklihood of your patch getting into the kernel.
+increase the likelihood of your patch getting into the kernel.
 
 
 15) The canonical patch format

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
