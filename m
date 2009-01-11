Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZAKDsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZAKDsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZAKDrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:47:53 -0500
Received: from web34403.mail.mud.yahoo.com ([66.163.178.152]:33264 "HELO
	web34403.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750815AbZAKDrw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:47:52 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jan 2009 22:47:52 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TXod+CARz6pZnDIf1Q30w8y/QEABQhkKVpofqTasgpzYUaMnf4m5z0gUN9/fIjXykt+e9LNBTa9Vd7IWMCUOMuqomVh42q9crQo18OG+atfArxpUPtESclMPyTYJOj6dKrqscAAY3QwvnIakOeemR2zyv+kJgGqDsDDBKR4QObU=;
X-YMail-OSG: RmXB2v4VM1lzIVzMMiD8qYHBisiON73HwVvuAUvXIyqe3Qp.tvtA4cKY.Yz.qcEqJo6odwZoqUtGp_G5uJ95fUYf2PG1XjHbvHYCqQxk4BU5J6s6PiwGOa7_vXCYrjjTQLCu_nIZKiDOlEfOocC.2MNeDWNSfFXy5h1XkgpcCemsEC.28BYljvGNKtq4x._iRjpX8xnsg4axzHqHe5cTdUvdKnpW0g--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sat, 10 Jan 2009 19:41:10 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <204164.94418.qm@web34403.mail.mud.yahoo.com>
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

Thanks in advance!

José Luís Marchetti


      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
