Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbZAXEof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbZAXEof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 23:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbZAXEoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 23:44:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:35956 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZAXEoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 23:44:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uvurV+PZocVeoUQXNrtUc7kacLky626N9Cj5fOHTbVjeNmhr+NI6gujWRFhPc+XdTM
         bNxRqMh445JYvFGsjvL7x5q4AdwqiemY1o3HjtLPf6pSwkloCx02HykKQWZTdct7Cc/h
         5Yt1YJelN/HliLTs0dJIcWk2k8C+HGM5YO2To=
From: Cheng Renquan <crquan@gmail.com>
To: Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, cr_quan@163.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] add the missing linux alpha port mailling list
Date: Sat, 24 Jan 2009 12:43:51 +0800
Message-Id: <1232772231-6523-2-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1232772231-6523-1-git-send-email-crquan@gmail.com>
References: <1232772231-6523-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3fe4dc2..38e8d09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -357,6 +357,7 @@ S:	Odd Fixes for 2.4; Maintained for 2.6.
 P:	Ivan Kokshaysky
 M:	ink@jurassic.park.msu.ru
 S:	Maintained for 2.4; PCI support for 2.6.
+L:	linux-alpha@vger.kernel.org
 
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
-- 
1.6.0.6

