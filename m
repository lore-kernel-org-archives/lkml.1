Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbXKVLZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbXKVLZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 06:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXKVLY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 06:24:56 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:55369 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbXKVLYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 06:24:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=B6BK/8I8DbHsGZEKMZx0j9Xk6diajRbCci3ksk/Enf2Z48tOhfbLW/ixgzLkEQJllGrAkLED5I0bZQhNchnFFQfTpBOn3hlDfxUqkJLZJPyRNfzyD7pPYKqxHpmFpJ9saG2uBwUhQE2oNGbKXOU8dsovPeyuyvGfnguyb9jELs4=
Message-ID: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
Date: Thu, 22 Nov 2007 12:24:54 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Where is the new timerfd?
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Davide,

Where is the new timerfd API.  In 2.6.24-rc3, I see the *old* API...

Cheers,

Michael
