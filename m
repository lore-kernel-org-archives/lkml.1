Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZAKDvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZAKDvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZAKDvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:51:38 -0500
Received: from web34402.mail.mud.yahoo.com ([66.163.178.151]:31807 "HELO
	web34402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750780AbZAKDvh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:51:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ESaBBrPNT6cbt0YW6Tys9DV79gU0UQMkSG7bHzP0e7Lnk05bWvbSZUxLwq9NL+6rA+qXXTTDbpirqCfZymH+w0fZT6MMv57xEyl66w7s7A96Mxkf/jIa+y4vPk31/cL/b03uxaSqY6slJPKxPRtGndXmlenFdsaCBvFkgGenPiQ=;
X-YMail-OSG: 8Ajjg9EVM1lnB.waOmNXdYg3sXETIWJ4hekiZNmV2G8zzK7LUAGOqFdHAwyzD05x5petrtZSo_OqpIIf939cygSEUKJHBIZeqN8bnFp90lkwR.k1BXkkU4le0NEVOspm6k20HpTMgkrajsB77yVylUYX6C6ZFL37PJUD7TZdEnZJuX.JVK_MHpLxN7Kn0yJzVttJPT0.ivlZSvJseLybpxAevCU4oQ--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sat, 10 Jan 2009 19:44:55 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
Subject: How to access a regular file from within a module ? 
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <888012.80064.qm@web34402.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to open/read/write/close a regular file from my device
driver.
I think it would be possible, but I am confused, the "The Linux Kernel
Module Programming Guide" states that I can not use standard libraries
from within a module, I know the standard library ends up calling
system calls, but which calls should I use to deal with regular
files ?
I am developing a Ethernet driver and the Mac address configuration

José Luís Marchetti

P.S. Posted the message again, previous one had no subject.


      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
