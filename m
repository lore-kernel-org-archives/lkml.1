Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYA3PWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYA3PWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYA3PWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:22:05 -0500
Received: from styx.suse.cz ([82.119.242.94]:33311 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754246AbYA3PWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:22:03 -0500
Date: Wed, 30 Jan 2008 16:22:01 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu
Subject: [PATCH] Change UDF maintainer
Message-ID: <20080130152201.GH16140@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Could you please include the patch below? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

I've tried to contact Ben Fennema a few times but without success. Since
I'm currently probably closest to being an UDF maintainer, I guess it's fine
to also change the entry in MAINTAINERS.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: bfennema@falcon.csc.calpoly.edu

diff --git a/MAINTAINERS b/MAINTAINERS
index ba05e80..d9cd824 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3851,8 +3851,8 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
 UDF FILESYSTEM
-P:	Ben Fennema
-M:	bfennema@falcon.csc.calpoly.edu
+P:	Jan Kara
+M:	jack@suse.cz
 W:	http://linux-udf.sourceforge.net
 S:	Maintained
 
