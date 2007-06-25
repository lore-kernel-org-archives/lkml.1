Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXFYKGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXFYKGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXFYKGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:06:12 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:33102 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbXFYKGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:06:11 -0400
Date: Mon, 25 Jun 2007 12:06:09 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <Pine.LNX.4.64.0706242126200.11964@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.BSO.4.63.0706251153060.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
 <Pine.LNX.4.64.0706242126200.11964@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-624157032-1182765969=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-624157032-1182765969=:25800
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 24 Jun 2007, Jan Engelhardt wrote:

>
> On Jun 24 2007 21:24, Tomasz K³oczko wrote:
>> Try to answer on question "ALSA or OSS ?" using *only* technical arguments.
>
> Ok: The OSS cs46xx driver did not support the rear 2 channels.

Yes it is true .. OSS (Hannu tree) dos not provide rear 2 channels in
cs46xx driver because .. in this OSS tree there is no cs46xx driver :>

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-624157032-1182765969=:25800--
