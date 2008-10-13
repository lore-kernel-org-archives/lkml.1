Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYJMCrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYJMCrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 22:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYJMCrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 22:47:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:43199 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYJMCrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 22:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=g4tUdKhMcfLxTj/y0drRtbhRniUtjRXgY2q5tzbYai7DgMzkXfGErvNnqIbfsdvMF4
         bxFKRxpZIsEiLXeUDpeKECvjIlsdDvAc88X+UIzBpWEPoDFrvjnq0qPq24rJeb32OtiM
         jjfOXc5T3o9lfh2lQHzj0m3oig0rbbajoCsJc=
Date: Mon, 13 Oct 2008 10:48:07 +0800
From: Jianjun Kong <kongjianjun@gmail.com>
To: randy.dunlap@oracle.com
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATH] MAINTAINERS remove the last colon from headings
Message-ID: <20081013024807.GA7041@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianjun Kong <kongjianjun@gmail.com>

Remove the last ending ':' from some of the Topic lines for consistency.

Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6ba3ee8..fb1aad7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3925,7 +3925,7 @@ M:	jbglaw@lug-owl.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-STABLE BRANCH:
+STABLE BRANCH
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
 P:	Chris Wright
-- 
1.5.2.5

