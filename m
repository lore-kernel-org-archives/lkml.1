Return-Path: <linux-kernel-owner+w=401wt.eu-S965783AbXHaVZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965783AbXHaVZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966383AbXHaVYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:24:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:39930 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965586AbXHaVYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=cEp4Bze7o85B0UjmcJwzcMGitJ+j8TRsgpHWlvt+egtGha7Bwl/tWDJ8phm3a7+RtxtPrheoaXkh109iuXJguviISczSWAagHu9VOfC74zsBtY8E+qwXmbbob4z4HqxfHgEQk3cRplZ2E1bCon9yHDEyWmAO80gC2ovuPSakmqo=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 4/5][resend] Add a 00-INDEX file to Documentation/telephony/
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux@quicknet.net, Greg Herlein <gherlein@quicknet.net>,
       Ed Okerson <eokerson@quicknet.net>, Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200708120045.03032.jesper.juhl@gmail.com>
In-Reply-To: <200708120045.03032.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 31 Aug 2007 23:21:29 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708312321.30099.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a 00-INDEX file to Documentation/telephony/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |    4 ++++
 1 file changed, 4 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ linux-2.6/Documentation/telephony/00-INDEX	2007-08-11 23:55:54.000000000 +0200
@@ -0,0 +1,4 @@
+00-INDEX
+	- this file.
+ixj.txt
+	- document describing the Quicknet drivers.



