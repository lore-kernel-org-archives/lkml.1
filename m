Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbXHBAAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbXHBAAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXHBAAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:00:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:46729 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbXHBAAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=izK1JV5W3PS3M/y3UxfI7UJxF3nPWsHWZ6zzvoMALc+rqfV+fti2tOwzNM3jmqWVJqhYHOaDBjIWuH5/PeLrerKjZ4YSXosft8tN6A68DmPlC9B0zvR5314ifmzEqpVl6/Jf05I6SbmXulQmUMdlZidsJS6iAXYoFVkKWGhvGhk=
Message-ID: <46B11E7A.4050908@googlemail.com>
Date: Thu, 02 Aug 2007 01:59:54 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH -mm] linux-audit list is subscribers-only 
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

--- linux-2.6.23-rc1-mm/MAINTAINERS.orig	2007-08-02 01:51:40.000000000 +0200
+++ linux-2.6.23-rc1-mm/MAINTAINERS	2007-08-02 01:52:17.000000000 +0200
@@ -672,7 +672,7 @@ S:	Maintained
 AUDIT SUBSYSTEM
 P:	David Woodhouse
 M:	dwmw2@infradead.org
-L:	linux-audit@redhat.com
+L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
 T:	git kernel.org:/pub/scm/linux/kernel/git/dwmw2/audit-2.6.git
 S:	Maintained

