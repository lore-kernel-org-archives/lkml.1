Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZANTza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZANTza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZANTzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:55:10 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3924 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbZANTzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:55:09 -0500
Subject: Re: [PATCH 0/10] MAINTAINERS - script, patterns, and misc fixes
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, pavel@ucw.cz, linux-kernel@vger.kernel.org
In-Reply-To: <1231961837.30095.23.camel@localhost>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
	 <20090113125435.4821123a.akpm@linux-foundation.org>
	 <1231907210.7935.527.camel@localhost>
	 <20090113231329.ee0e534f.akpm@linux-foundation.org>
	 <1231961837.30095.23.camel@localhost>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 11:55:39 -0800
Message-Id: <1231962939.30095.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 11:37 -0800, Joe Perches wrote:
> max-history

Not quite.

commit 0cd5dbd1d732a36777f27f1250622554e7aa3b62
Author: Joe Perches <joe@perches.com>
Date:   Wed Jan 14 11:52:48 2009 -0800

    scripts/get_maintainer.pl - Correct --help for git-since
    
    Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 48e2d5f..1ed62a8 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -285,7 +285,7 @@ MAINTAINER field selection options:
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: 1)
     --git-max-maintainers => maximum maintainers to add (default: 5)
-    --git-max-history => git history to use (default: 1-year-ago)
+    --git-since => git history to use (default: 1-year-ago)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any


