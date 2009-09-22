Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZIVKCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZIVKCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbZIVKCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:02:30 -0400
Received: from mail-pz0-f173.google.com ([209.85.222.173]:38554 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbZIVKCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:02:30 -0400
MIME-Version: 1.0
Date: Tue, 22 Sep 2009 15:32:33 +0530
Message-ID: <d760cf2d0909220302h1d74915atde0f6fe3b0fb3d6c@mail.gmail.com>
Subject: TODO file for ramzswap
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TODO file for ramzswap.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>

---
 drivers/staging/ramzswap/TODO |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ramzswap/TODO b/drivers/staging/ramzswap/TODO
new file mode 100644
index 0000000..bac40d6
--- /dev/null
+++ b/drivers/staging/ramzswap/TODO
@@ -0,0 +1,6 @@
+TODO:
+	- Add support for swap notifiers
+	- Remove CONFIG_ARM hack
+
+Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
+Nitin Gupta <ngupta@vflare.org>
