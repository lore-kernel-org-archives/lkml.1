Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZBTAgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZBTAgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZBTAgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:36:13 -0500
Received: from web34404.mail.mud.yahoo.com ([66.163.178.153]:23156 "HELO
	web34404.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752689AbZBTAgM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:36:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=g52xUkF7DRw9URUuoyAoTddWJqgooQNSRIydTicn61KGz2AOGkgfBrPgZpma/MNhkxabZXgeiejtMEeFa4oEzkaomTxGtf3aUR9+w28+DUO3QOmdzv3NkiLZcpCPPrx15tJJyPPifDfVF9ZlPh8v3cbsutiQtSPQuvypjXPwHh8=;
X-YMail-OSG: 2noUTxIVM1k_vkGJ3K4PCZXOQs7iWOHUmBV8p6Wv64ySUcXAFoQ4Fg1dXzwuvbk1NgvFZk8jbUwkBtwJNtltVoGbm_5JGnCpN4PQuiA_VqhqQ0JXRyuTH6VH.XBNm.Nyp.krVcNsylkxiLceTYft2LO.o6bpkylqTvS1Ztzj9DOAecvJlSltEX4_ErEnVU7lJBtPpHkVdpOdS0n1nCtcJ.sxY2bgMQ--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 19 Feb 2009 16:36:11 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
Subject: Re: Is interrupt priority supported ?
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <499DF89F.5030504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <786756.68018.qm@web34404.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> You didn't say what platform this was, it likely
> matters a fair bit.

Mips processor, is this what you asked ?

> 
> I don't know that changing interrupt priority is
> necessarily likely to do much, though. If the network card
> driver is disabling interrupts while handling packets and
> that's what's causing the problem, then it won't
> help.

Yes, I checked that, the Ethernet driver is not disabling the interrupts.

Jose Luis Marchetti


      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
