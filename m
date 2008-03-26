Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYCZWg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYCZWg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYCZWgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:36:48 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:3796 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYCZWgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=KLl9/vuogN3DtfmZKZDzulc3+YrNIL0DQ3juQhn0Li43hjExxahqHgQ8sO67MjN4MmAZpRQGt6ig8AIaTXCF/6PLXaQwl6ndWgLW2zEa76rutoTIqMMojyzsHZRqC9SyNXxfarQNX8AeoM1NUwu9mY9eCwU33DjI3nMpp4fSXZQ=
Date: Wed, 26 Mar 2008 23:36:30 +0100 (CET)
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, jesper.juhl@gmail.com
Subject: [PATCH][TRIVIAL] Remove a few junk lines from
 Documentation/feature-removal-schedule.txt
Message-ID: <alpine.LNX.1.00.0803262334580.2872@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove junk formatting from Documentation/feature-removal-schedule.txt

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 feature-removal-schedule.txt |    2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bf0e3df..518fe3a 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -221,8 +221,6 @@ Who:	Thomas Gleixner <tglx@linutronix.de>
 
 ---------------------------
 
----------------------------
-
 What:	i2c-i810, i2c-prosavage and i2c-savage4
 When:	May 2008
 Why:	These drivers are superseded by i810fb, intelfb and savagefb.


