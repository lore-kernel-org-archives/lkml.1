Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYESWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYESWCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764754AbYESWBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:01:16 -0400
Received: from sous-sol.org ([216.99.217.87]:41352 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764651AbYESWBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:01:14 -0400
Date: Mon, 19 May 2008 14:58:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: LSM: MAINTAINERS points to no longer existing URL
Message-ID: <20080519215843.GJ30402@sequoia.sous-sol.org>
References: <20080519214201.GB17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519214201.GB17716@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> MAINTAINERS says:
> 
> LINUX SECURITY MODULE (LSM) FRAMEWORK
> P:      Chris Wright
> M:      chrisw@sous-sol.org
> L:      linux-security-module@vger.kernel.org
> W:      http://lsm.immunix.org
> T:      git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
> S:      Supported
> 
> But http://lsm.immunix.org no longer exists.

Indeed, queueing this.

thanks,
-chris
--

From: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] LSM: remove stale web site from MAINTAINERS

Pointed out by Adrian Bunk.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 915ad48..22ed22c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2548,7 +2548,6 @@ LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	linux-security-module@vger.kernel.org
-W:	http://lsm.immunix.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
