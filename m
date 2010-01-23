Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202Ab0AWAXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0AWAXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327Ab0AWASz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:18:55 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44817 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab0AWASv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RVuQQk46fYHIee7Obbxeu+7g/WDHbIZVlsuww5/U0f55fcsOleepmWZq//KAlwRzvr
         0M1OKHVeaaze09srKcJtgfSNKaRrHHPiEHtJxB8JA9duDA/UzcEsvTGUbI3bXQrbq3+c
         BSYXWkvPhBpxtZuhFmzkr66HW2X/SiU8iuNb8=
Subject: [PATCH 0/8] Cleanups for mtd translation layer (broken up)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 02:18:45 +0200
Message-ID: <1264205925.31827.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series is identical to series I posted very recently, but I
have broken up the patch #3 into smaller pieces.
Note that I want to merge it in kernel as a single patch, to avoid
bisect failures. This is for review.

Best regards,
Maxim Levitsky

