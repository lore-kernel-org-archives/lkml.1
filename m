Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbYGSBQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbYGSBQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYGSBQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:16:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51420 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYGSBQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:16:16 -0400
Date: Sat, 19 Jul 2008 11:16:14 +1000
From: Simon Horman <horms@verge.net.au>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>
Subject: Re: [PATCH] kdump: Update kdump documentation as
	kexec-tools-resting has been renamed kexec-tools
Message-ID: <20080719011612.GA20745@verge.net.au>
References: <20080719005835.GA19032@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080719005835.GA19032@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 
Reposting to Vivek's new email address

Index: linux-2.6/Documentation/kdump/kdump.txt
===================================================================
--- linux-2.6.orig/Documentation/kdump/kdump.txt	2008-07-19 10:27:50.000000000 +1000
+++ linux-2.6/Documentation/kdump/kdump.txt	2008-07-19 10:51:57.000000000 +1000
@@ -65,26 +65,26 @@ Install kexec-tools
 
 2) Download the kexec-tools user-space package from the following URL:
 
-http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools-testing.tar.gz
+http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz
 
-This is a symlink to the latest version, which at the time of writing is
-20061214, the only release of kexec-tools-testing so far. As other versions
-are released, the older ones will remain available at
-http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
+This is a symlink to the latest version.
 
-Note: Latest kexec-tools-testing git tree is available at
+The latest kexec-tools git tree is available at:
 
-git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools-testing.git
+git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools.git
 or
-http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools-testing.git;a=summary
+http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git
+
+More information about kexec-tools can be found at
+http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html
 
 3) Unpack the tarball with the tar command, as follows:
 
-   tar xvpzf kexec-tools-testing.tar.gz
+   tar xvpzf kexec-tools.tar.gz
 
 4) Change to the kexec-tools directory, as follows:
 
-   cd kexec-tools-testing-VERSION
+   cd kexec-tools-VERSION
 
 5) Configure the package, as follows:
 

