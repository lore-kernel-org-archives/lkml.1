Return-Path: <linux-kernel-owner+w=401wt.eu-S933173AbXBRKGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbXBRKGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 05:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXBRKGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 05:06:44 -0500
Received: from webmail12.mail.yandex.net ([213.180.223.102]:33910 "EHLO
	webmail12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbXBRKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 05:06:43 -0500
Date: Sun, 18 Feb 2007 13:06:21 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D8251D.000005.19402@webmail12.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: tty driver: TASKLET or WORKQUEUE?
X-MsgDayCount: 6
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.221.32
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Which concept is better for tty driver: TASKLET or WORKQUEUE?
I want to make ISR much faster and call after that timing consume function.
