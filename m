Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbXCGPGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbXCGPGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbXCGPGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:06:33 -0500
Received: from mfront7.mail.yandex.net ([213.180.223.96]:34113 "EHLO
	mfront7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXCGPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:06:32 -0500
Date: Wed, 7 Mar 2007 18:06:19 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45EED4EB.000002.11493@mfront7.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: pxa.c cat problem
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.215.18
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have two PXA Linux boards, I connected them and tried cat myfile > /dev/ttyS0 on  one board and cat < /dev/ttyS0 on another. But I can't see nothing. 

What is wrong with my pxa.c driver?

thanks
