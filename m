Return-Path: <linux-kernel-owner+w=401wt.eu-S965570AbXDVJRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbXDVJRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965583AbXDVJRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:17:38 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:37505 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965570AbXDVJRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=VabiRh0vYq7X1FmVhBuQ3/1hA4mAirikxmUzwtuvoDlQGLj1TtvcfwFqZdo4IC9PbkuZuJHSeh19b32k2bRx+9sZnC758FDUPrNOeskPAMs7kvUZH8+UrTmNcZ8Vdjh2tZ7Zggzkr8y/L6rTh9yxIYnuoKX5hXn1TJEKN4R4x84=
Date: Sun, 22 Apr 2007 18:12:04 +0900
To: Andi Kleen <andi@firstfloor.org>,
       Scott Porter <scott@opengridcomputing.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: [PATCH] fault injection: add entry to MAINTAINERS
Message-ID: <20070422091204.GC4246@APFDCB5C>
Mail-Followup-To: Akinobu Mita <Akinobu.Mita@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Scott Porter <scott@opengridcomputing.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org
References: <1177095354.25165.48.camel@scott-desktop.site> <1177192363.25165.101.camel@scott-desktop.site> <20070421221033.GA30496@one.firstfloor.org> <20070422070603.GA30662@APFDCB5C> <20070422090930.GA4246@APFDCB5C> <20070422091108.GB4246@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422091108.GB4246@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
From: Akinobu Mita <akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add maintainer for fault injection support.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6-git/MAINTAINERS
===================================================================
--- 2.6-git.orig/MAINTAINERS
+++ 2.6-git/MAINTAINERS
@@ -1355,6 +1355,11 @@ M:	kevin.curtis@farsite.co.uk
 W:	http://www.farsite.co.uk/
 S:	Supported
 
+FAULT INJECTION SUPPORT
+P:	Akinobu Mita
+M:	akinobu.mita@gmail.com
+S:	Supported
+
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
