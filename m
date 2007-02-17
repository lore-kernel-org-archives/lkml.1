Return-Path: <linux-kernel-owner+w=401wt.eu-S1946607AbXBQKGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946607AbXBQKGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965126AbXBQKGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:06:44 -0500
Received: from tide.yandex.ru ([213.180.200.37]:51823 "EHLO tide.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965119AbXBQKGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:06:43 -0500
Date: Sat, 17 Feb 2007 13:06:27 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D6D3A3.000001.04520@tide.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: Linux tty driver question
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.244.133
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on Linux tty driver (based on tiny_tty).

How can I provide in my driver Linux cat operation (e.g.cat < ttyS3)?

What should I implement exactly?

Thankx
