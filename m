Return-Path: <linux-kernel-owner+w=401wt.eu-S1030294AbXCCOq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030294AbXCCOq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030303AbXCCOq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:46:56 -0500
Received: from webmail13.mail.yandex.net ([213.180.200.6]:41282 "EHLO
	webmail13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030294AbXCCOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:46:55 -0500
Date: Sat, 3 Mar 2007 17:46:37 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45E98A4D.000006.28746@webmail13.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question: 20 microseconds delay
X-MsgDayCount: 2
X-BornDate: 1134853200
In-Reply-To: <45E986E2.3010203@gmail.com>
Reply-To: Mockern@yandex.ru
References: <45E98415.000002.30135@webmail9.yandex.ru> <45E986E2.3010203@gmail.com>
X-Source-Ip: 84.185.232.70
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that I need to use wait_event_timeout function.

>Mockern napsal(a):
>> Hi,
>> 
>> I have a question.
>> 
>> I need to use 20 microsecond delay in my driver.
>> What exact jiffies value I should define to get 20 microseconds?
>
>It's subjiffy delay unless you use 50000 HZ :). Use udelay.
>
>regards,

-- 
Яндекс.Почта: объем почтового ящика не ограничен! http://mail.yandex.ru/monitoring/
