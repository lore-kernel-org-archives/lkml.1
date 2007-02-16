Return-Path: <linux-kernel-owner+w=401wt.eu-S964824AbXBPNsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbXBPNsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964834AbXBPNsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:48:00 -0500
Received: from camay.yandex.ru ([213.180.200.33]:53202 "EHLO camay.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964824AbXBPNsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:48:00 -0500
Date: Fri, 16 Feb 2007 16:47:44 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D5B600.000007.30983@camay.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: bloc_til_ready in tty driver
X-MsgDayCount: 3
X-BornDate: 1134853200
In-Reply-To: <45D5A7FE.7010309@gmail.com>
Reply-To: Mockern@yandex.ru
References: <45D5A1E0.000004.21866@tide.yandex.ru> <45D5A7FE.7010309@gmail.com>
X-Source-Ip: 84.185.222.204
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanx for your respond,

I did not implement this function in my tty driver.

Does it help to work my driver with cat Linux operation?
(e.g. cat < ttyS10)


>Mockern napsal(a):
>> What for is "bloc_til_ready" function in tty drivers?
>
>Most drivers waits for hardware to detect carrier and for closed callout.
>
>regards,

-- 
Сегодня удачный день, чтобы завести почту на Яндексе http://mail.yandex.ru
