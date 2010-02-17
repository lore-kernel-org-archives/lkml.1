Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0BQVtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:49:36 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54052 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab0BQVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lsn/AIUelr9dLqYpgG8UcvG702YEOh2/5ob6Bl4UR31f6V9jgo4rPEb8i70NDLmn/S
         aelO39xIP0gsG3Os9t5Vwx9pj0HeuCdF8wzK0mu58Y96cTmEmrwwGGfJ4aNtiTiYtra0
         u/sKAcARfdOLxuiE9Dw3+HHqZ2BEpm6gIFG/4=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
Subject: [PATCH 0/14 V9] Work to enable SmartMedia/xD support in mtd
Date: Wed, 17 Feb 2010 23:49:10 +0200
Message-Id: <1266443364-4538-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is slightly updated version of my patchset.
Now I can tell you for sure that hotplug works.
It was used/abused for long time.
I did some changes in richoh card reader driver, to work better after resume
and renamed it to r852.

I kindly ask you to merge this patchset to 2.6.34.
If I/users find other bugs they can be addressed by follow up patches.

Best regards,
	Maxim Levitsky



