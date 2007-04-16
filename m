Return-Path: <linux-kernel-owner+w=401wt.eu-S1031000AbXDPWVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031000AbXDPWVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031002AbXDPWVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:21:48 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:44637 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031000AbXDPWVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n7ZwVYMYwz+yrM/K0hFSH2pEtrZQffbdDIN7sMvKaznR9a5mk1VvosaU1uoEqp3uJm6O7DxaM5fkikxFhxbPMbCoMOffYUQDp7MJka0Z0bDpvi5ibI4U0zyMRmDU2sVoaU5MZtQRec2URNofT5k+DrDnOsTL6t/A6etxiBQlf9s=
Message-ID: <653402b90704161521t9d39495s720a3c3c5f374173@mail.gmail.com>
Date: Tue, 17 Apr 2007 00:21:46 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: akpm@osdl.org
Subject: [PATCH -rc7 Re] [Trivial] Spelling at drivers/video/Kconfig
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <653402b90704150334o4e81df48n5bf5dc221da07d2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <653402b90704150334o4e81df48n5bf5dc221da07d2a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Trivial patch, against -rc6. I don't know if anyone has fixed this by now."

Resend comment: Still present in -rc7.
---

 drivers/video/Kconfig:
    - Spelling: "Frambuffer hardware support"

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
---
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index e4f0dd0..8372ace 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -139,7 +139,7 @@ config FB_TILEBLITTING
         This is particularly important to one driver, matroxfb.  If
         unsure, say N.

-comment "Frambuffer hardware drivers"
+comment "Frame buffer hardware drivers"
        depends on FB

 config FB_CIRRUS

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
