Return-Path: <linux-kernel-owner+w=401wt.eu-S1751146AbXBPG7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbXBPG7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbXBPG7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:59:51 -0500
Received: from webmail19.mail.yandex.net ([213.180.200.53]:42342 "EHLO
	webmail19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbXBPG7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:59:50 -0500
Date: Fri, 16 Feb 2007 09:59:35 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D55657.000003.30666@webmail19.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: cat, cp operations for tty driver (like for char one) 
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.222.204
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about linux tty driver 

how to support cp, cat operations in tty driver (like tiny_tty)?
(e.g. echo "hello tty" > /dev/ttyS3, cat < ttyS10 etc)

There a lot of examples with char drivers, but I could not find it for tty
Linux driver. 


