Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZDMPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZDMPVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZDMPVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 11:21:36 -0400
Received: from verein.lst.de ([213.95.11.210]:34666 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbZDMPVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 11:21:35 -0400
Date: Mon, 13 Apr 2009 17:20:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: torvalds@osdl.org, roland@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] add ptrace entry to MAINTAINERS
Message-ID: <20090413152010.GA16682@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the LF collab summit we decided to make Roland official ptrace
maintainer not just the defacto one he has been for a couple of years
now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS	2009-04-13 17:17:16.907949256 +0200
+++ linux-2.6/MAINTAINERS	2009-04-13 17:18:35.028962859 +0200
@@ -3597,6 +3597,12 @@ M:	jim@jtan.com
 L:	cbe-oss-dev@ozlabs.org
 S:	Maintained
 
+PTRACE SUPPORT
+P:	Roland McGrath
+M:	roland@redhat.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely
 M:	isely@pobox.com
