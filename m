Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZJ0QZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZJ0QZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbZJ0QZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:25:42 -0400
Received: from kroah.org ([198.145.64.141]:59443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbZJ0QZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:25:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Oct 27 09:21:17 2009
Message-Id: <20091027162117.660026218@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Oct 2009 09:18:23 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: "John W. Linville" <linville@tuxdriver.com>, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/4] Staging: strip: add TODO file
References: <20091027161822.657794160@mini.kroah.org>
Content-Disposition: inline; filename=staging/staging-strip-add-todo-file.patch
In-Reply-To: <20091027162142.GA23728@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/strip/TODO |    7 +++++++
 1 file changed, 7 insertions(+)

--- /dev/null
+++ b/drivers/staging/strip/TODO
@@ -0,0 +1,7 @@
+TODO:
+	- step up and maintain this driver to ensure that it continues
+	  to work.  Having the hardware for this is pretty much a
+	  requirement.  If this does not happen, the will be removed in
+	  the 2.6.35 kernel release.
+
+Please send patches to Greg Kroah-Hartman <greg@kroah.com>.


