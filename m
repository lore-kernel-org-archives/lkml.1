Return-Path: <linux-kernel-owner+w=401wt.eu-S933973AbXCFHkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973AbXCFHkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933977AbXCFHkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:40:43 -0500
Received: from webmail13.mail.yandex.net ([213.180.200.6]:60174 "EHLO
	webmail13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973AbXCFHkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:40:42 -0500
Date: Tue, 6 Mar 2007 10:40:29 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45ED1AED.000003.06978@webmail13.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: Problem: how to make kernel thread more faster?
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.248.185
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Is there a way how to make kernel thread more faster?

I put some of my code to the kthread, but I noticed that kthread sends data more slow
than original driver without kthread.

Thank you

