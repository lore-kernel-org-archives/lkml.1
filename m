Return-Path: <linux-kernel-owner+w=401wt.eu-S966438AbXHaVZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966438AbXHaVZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966352AbXHaVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:24:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:39930 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966326AbXHaVY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=ndPmzCC3+NvZDW+UOtzfCiEZvqBkZ/mNGqF7WeE7D+ZFI0hJPDmIeROMa0E4SZCQFf0jxiZjtwYCXW0gFOSjGYjXQYXjuLHWsiP2Hf5GOjNyMxTywoNuAMteBVHozuWAZ9v3mHsp6Ud5wu/GLOo3i5asAvmise6Jxp6u4hcoqKw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 3/5][resend] Add a 00-INDEX file to Documentation/sysctl/
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@nl.linux.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200708120045.03032.jesper.juhl@gmail.com>
In-Reply-To: <200708120045.03032.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 31 Aug 2007 23:21:20 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708312321.20622.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a 00-INDEX file to Documentation/sysctl/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ linux-2.6/Documentation/sysctl/00-INDEX	2007-08-11 23:52:50.000000000 +0200
@@ -0,0 +1,16 @@
+00-INDEX
+	- this file.
+README
+	- general information about /proc/sys/ sysctl files.
+abi.txt
+	- documentation for /proc/sys/abi/*.
+ctl_unnumbered.txt
+	- explanation of why one should not add new binary sysctl numbers.
+fs.txt
+	- documentation for /proc/sys/fs/*.
+kernel.txt
+	- documentation for /proc/sys/kernel/*.
+sunrpc.txt
+	- documentation for /proc/sys/sunrpc/*.
+vm.txt
+	- documentation for /proc/sys/vm/*.



