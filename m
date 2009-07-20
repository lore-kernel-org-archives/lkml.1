Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbZGTJqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbZGTJqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 05:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZGTJqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 05:46:43 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:48612 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZGTJqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 05:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=gFyM+zJRKk74YX/zEm8nIVOR8Zn75bsSBaURAteEzyrhflx+PpzOu1y5PIthiTuQ6R
         0KXNgAzUT1iKDwheYC64x1WgiJ4ZdBBl5Hdww+TMXNh5sq+fL99CmOm+tKbJSVT1T0ox
         MzqT92rirHmy+tiy0OeGQOqnwpypdhjTBbAsI=
MIME-Version: 1.0
Date: Mon, 20 Jul 2009 15:16:42 +0530
Message-ID: <9debc4410907200246r388b3b5h8137be05dc33014@mail.gmail.com>
Subject: [PATCH] Spelling correction in Motorola USB Phone driver
From: Maxin John <maxin.john@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Spelling correction in Motorola USB Phone driver

Changed: * Mororola should be using the CDC ACM USB spec, but instead
To: * Motorola should be using the CDC ACM USB spec, but instead

Signed-off-by: Maxin B. John <maxinbjohn@gmail.com>
---
diff -uNrb linux-2.6.30.2-orig/drivers/usb/serial/moto_modem.c
linux-2.6.30.2/drivers/usb/serial/moto_modem.c
--- linux-2.6.30.2-orig/drivers/usb/serial/moto_modem.c 2009-07-20
09:09:19.000000000 +0530
+++ linux-2.6.30.2/drivers/usb/serial/moto_modem.c      2009-07-20
15:07:10.000000000 +0530
@@ -8,7 +8,7 @@
  *  published by the Free Software Foundation.
  *
  * {sigh}
- * Mororola should be using the CDC ACM USB spec, but instead
+ * Motorola should be using the CDC ACM USB spec, but instead
  * they try to just "do their own thing"...  This driver should handle a
  * few phones in which a basic "dumb serial connection" is needed to be
  * able to get a connection through to them.
