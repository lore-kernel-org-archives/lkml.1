Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbXCDRFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbXCDRFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXCDRFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:05:04 -0500
Received: from webmail14.yandex.ru ([213.180.200.21]:60730 "EHLO
	webmail14.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbXCDRFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:05:02 -0500
Date: Sun, 4 Mar 2007 20:04:48 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45EAFC30.000004.20012@webmail14.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: kernel threads locking data 
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.235.185
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

how is better to lock data (a buffer) which is used by 2 kernel threads?

thank you
