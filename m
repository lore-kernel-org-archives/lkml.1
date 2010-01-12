Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841Ab0ALWAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0ALWAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448Ab0ALWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:00:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0ALWAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:00:03 -0500
Date: Tue, 12 Jan 2010 16:59:52 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: remove my email address from checkpatch.
Message-ID: <20100112215952.GA15753@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this will stop people emailing me about it.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc4114f..3257d3d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1,5 +1,5 @@
 #!/usr/bin/perl -w
-# (c) 2001, Dave Jones. <davej@redhat.com> (the file handling bit)
+# (c) 2001, Dave Jones. (the file handling bit)
 # (c) 2005, Joel Schopp <jschopp@austin.ibm.com> (the ugly bit)
 # (c) 2007,2008, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite)
 # (c) 2008,2009, Andy Whitcroft <apw@canonical.com>
