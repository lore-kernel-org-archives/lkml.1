Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZCSNvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZCSNvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbZCSNvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:51:12 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:62484 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZCSNvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=o2IBst1GgQUTlX/bI3ZVHG/azU4FRJ6D83zSh0Rwf3L3ce3CuGeVA4SMjtCUKX8HcC
         0njle3RosqHpaI0tmnfbSNZw9cxOXtGJaOb7bf6UFoLhy3nEge+xhpdjp7nIV/qK5lXZ
         D1C/OP0/udSOE+/0gxY6W3jxrmrXu8P9S4P6M=
MIME-Version: 1.0
Date: Thu, 19 Mar 2009 14:51:07 +0100
Message-ID: <739e73230903190651w4fff7aaen818a42540ffbdc8d@mail.gmail.com>
Subject: [PATCH] input/joystick: add driver fortius 1942
From: Peta Blaha <blahapeta@gmail.com>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Fortius 1942 device.

Signed-off-by: Petr Blaha <blahapeta@gmail.com>

---

This is driver for bycicle Fortius 1942. checked, patch is signed.
It's a bit long. Patch for linux kernel and source are on page

http://code.google.com/p/fortius/

fortius_1942.patch2  is the patch
 fortius_1942.0.0.2_doc.c  is kernel module

It should be ok now.

Petr
