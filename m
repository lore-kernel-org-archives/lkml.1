Return-Path: <linux-kernel-owner+w=401wt.eu-S965268AbXBQOrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbXBQOrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 09:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965274AbXBQOrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 09:47:01 -0500
Received: from webmail9.mail.yandex.net ([213.180.223.100]:40865 "EHLO
	webmail9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268AbXBQOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 09:47:00 -0500
Date: Sat, 17 Feb 2007 17:46:45 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D71555.000002.20869@webmail9.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: line discipline and tty driver
X-MsgDayCount: 5
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.244.133
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question regarding line discipline:

in http://www.linux.it/~rubini/docs/serial/serial.html is shown data flow for Linux tty driver.

When it's necessary to use line discipline in tty driver (to call ldisc.write(), ldisc.read(), ldisc.receive_buf()) and when I can ignore line discipline in my tty driver? 

Thanks 
