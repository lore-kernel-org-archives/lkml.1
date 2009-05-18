Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZERNsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZERNsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZERNrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:47:51 -0400
Received: from web26101.mail.ukl.yahoo.com ([217.146.182.142]:21719 "HELO
	web26101.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750978AbZERNrv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:47:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RILuFy0cMkxm6JBls+X1ZeiEi6gIRz9iRDDLG84YyBrLcSSyA2k7teqX4Go26xhnBJ9atzXurbPanXCAvJeGcZMBAR+/7Ozp0kb1sodb9Thz3Ua6c0AvCU1rAdKHE6GQtvooubS1dSYhcA8iH6dUw0aB0DkzOV0OAubqQ4GYgBY=;
Message-ID: <223602.79528.qm@web26101.mail.ukl.yahoo.com>
X-YMail-OSG: L3mixI4VM1nCO5GiTkxdnuPzPSUUr4NeFo.zqBdjxxiaREwktQjc9zDDRagRsz6Ecsc4r6tubBVN6SesHHwf5O8Y_0MisU9M8tOTL34.QxmIoRJsIEjIHnB7dVzcGIOncrtouJ6AHfgZzXEQkFo5fwVNSI5IIYIDZQGCtbz88dGH7NTjc7ZDHoGjtTAu2wefxeEIuyHE1JjmrqQ2Z4uGBlbJk4x2jNWkeqttUfnEaJC9CWqL4OnQoXL1r6Lm27CGz3JpQNJWUaLhX1EB_4Rti17eBPqpGOjGLCE7pw.lCLME.MlDScLGdjzq4zh0vWIFpIONgkhcKArIZXoi3x0-
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Mon, 18 May 2009 13:47:50 +0000 (GMT)
From: John Zupfel <jzupfel@yahoo.co.uk>
Subject: Re: Houston, we have a problem: big file copying, USB, external disks
To: linux-kernel@vger.kernel.org,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Mon, 18/5/09, Ralf Hildebrandt <Ralf.Hildebrandt@charite.de> wrote:
> Does this happen AFTER a suspend/hibernate or ALL THE TIME?

All the time. And according to most of the reports, the slowdown usually starts after the first several hundred MiBs have been copied.


      
