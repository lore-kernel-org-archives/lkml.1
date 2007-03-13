Return-Path: <linux-kernel-owner+w=401wt.eu-S965699AbXCMMGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965699AbXCMMGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965702AbXCMMGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:06:19 -0400
Received: from colgate.yandex.ru ([213.180.200.34]:38781 "EHLO
	colgate.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965699AbXCMMGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:06:18 -0400
Date: Tue, 13 Mar 2007 15:06:12 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45F693B4.000001.09756@colgate.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: Question: kthread zombie process
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 83.64.219.194
X-Originating-Ip: 172.16.20.173
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I use kthread in my driver. The problem is that I can't kill process with kill_proc function. After rmmod my_driver, ps command shows again SW my_driver.

How can I remove this process?

Thank you

