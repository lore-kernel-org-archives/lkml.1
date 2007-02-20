Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbXBTMul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbXBTMul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 07:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932924AbXBTMul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 07:50:41 -0500
Received: from webmail16.mail.yandex.net ([213.180.200.38]:52263 "EHLO
	webmail16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913AbXBTMuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 07:50:40 -0500
Date: Tue, 20 Feb 2007 15:50:27 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45DAEE93.000001.01672@webmail16.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to limit flip buffer size in tty driver?
X-MsgDayCount: 2
X-BornDate: 1134853200
In-Reply-To: <20070220125329.55fb7210@localhost.localdomain>
Reply-To: Mockern@yandex.ru
References: <45DAB02A.000001.11699@soapbox.yandex.ru> <20070220125329.55fb7210@localhost.localdomain>
X-Source-Ip: 84.185.221.181
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Alan for your respond,

Could you help me with a problem which I have with my tty driver, please?

It does not work with Linux cat operation (but there are no problems to write, read with select from user space application!). 

regards,

Andy  



>On Tue, 20 Feb 2007 11:24:10 +0300 (MSK)
>"Mockern" <Mockern@yandex.ru> wrote:
>
>> Hello,
>> 
>> how to limit flip buffer size in tty driver?
>
>You don't.
>
>See Documentation/tty.txt and throttle/unthrottle
>
>Alan


-- 
Сегодня удачный день, чтобы завести почту на Яндексе http://mail.yandex.ru
