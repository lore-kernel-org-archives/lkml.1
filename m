Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXHMWgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXHMWgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXHMWgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:36:13 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:40546 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbXHMWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:date:to:subject:cc:message-id;
        b=Ot/7djFEOm0FGiqhkqkTjYa95r0W+yXpTMHS6J7E1XJycPx4bSXMDQ4KVoTDsCl3wKAEitDzwkf1hwOKLVw1EdFCnakHzTtHFGy8+WtSUVQn57VcBaoQj0dau6WxF7yHvfo/TF/IdZOyXf0+tn7334wodEYbj34xqG6wrCcNzmw=
From: mbressers@gmail.com
Date: Tue, 14 Aug 2007 00:37:29 +0200
To: linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] [TRIVIAL] fix spelling mistake   in drivers/usb/host/Kconfig
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Message-ID: <46c0dcd5.17e7300a.7396.ffff8322@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Bressers <mbressers@gmail.com>

Greetings,

A very trivial patch: fixes a spelling mistake in drivers/usb/host/Kconfig,
wrt the R8A66597_HCD driver. The patch applies to kernel 2.6.23-rc3.

Signed-off by: Maarten Bressers <mbressers@gmail.com>

---

--- a/drivers/usb/host/Kconfig.orig	2007-08-13 19:40:34.000000000 +0200
+++ b/drivers/usb/host/Kconfig	2007-08-13 19:40:44.000000000 +0200
@@ -237,7 +237,7 @@ config USB_SL811_CS
 	  module will be called "sl811_cs".
 
 config USB_R8A66597_HCD
-	tristate "R8A66597 HCD suppoort"
+	tristate "R8A66597 HCD support"
 	depends on USB
 	help
 	  The R8A66597 is a USB 2.0 host and peripheral controller.
