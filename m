Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYIZGtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYIZGtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYIZGtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:49:10 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:53160 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYIZGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=dbSE78WevweAEkcmhhtIolZJaTS7jMZytfH1qizJxaxAcLm/rmcCAoTbe/uv6uEGHK
         7UwFmTqX+hF/pn8eGttDOSFQnUj9Pc/7vjm/84jPUsf3HQTRK9Pv46z6zgde3VutUKrr
         5dGSj9b8MsZx8N/9JXtKrZPauHCDZB8dnYAMI=
Message-ID: <cfd18e0f0809252349k76604dfy8f0980739194b3ce@mail.gmail.com>
Date: Fri, 26 Sep 2008 08:49:08 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: add mailing list for man-pages
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays, man-pages has an associated mailing list.  Mention that list
in MAINTAINERS.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3596d17..8d16c12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2706,6 +2706,7 @@ MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2,
3, 4, 5, and 7
 P:     Michael Kerrisk
 M:     mtk.manpages@gmail.com
 W:     http://www.kernel.org/doc/man-pages
+L:     linux-man@vger.kernel.org
 S:     Supported

 MARVELL LIBERTAS WIRELESS DRIVER
