Return-Path: <linux-kernel-owner+w=401wt.eu-S1945940AbXBPPg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945940AbXBPPg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945941AbXBPPg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:36:58 -0500
Received: from webmail9.mail.yandex.net ([213.180.223.100]:50371 "EHLO
	webmail9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945940AbXBPPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:36:57 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 10:36:57 EST
Date: Fri, 16 Feb 2007 18:29:22 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D5CDD2.000001.03232@webmail9.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: bloc_til_ready in tty driver
X-MsgDayCount: 6
X-BornDate: 1134853200
In-Reply-To: <45D5BF9E.4030903@gmail.com>
Reply-To: Mockern@yandex.ru
References: <45D5A1E0.000004.21866@tide.yandex.ru> <45D5A7FE.7010309@gmail.com> <45D5B600.000007.30983@camay.yandex.ru> <45D5BF9E.4030903@gmail.com>
X-Source-Ip: 84.185.222.204
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much

>Mockern napsal(a):
>> Thanx for your respond,
>> 
>> I did not implement this function in my tty driver.
>> 
>> Does it help to work my driver with cat Linux operation?
>> (e.g. cat < ttyS10)
>
>Help in which way? If you haven't implemented it, it'll behave like there was 
>O_NONBLOCK passed to open() call or TIOCSSOFTCAR ioctl with nonzero param was 
>invoked.
>
>regards,

-- 
Яндекс.Почта: объем почтового ящика не ограничен! http://mail.yandex.ru/monitoring/
