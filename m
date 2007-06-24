Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbXFXTZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbXFXTZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXFXTY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:24:58 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:22616 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXFXTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:24:57 -0400
Date: Sun, 24 Jun 2007 21:24:54 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <20070624200837.16e11305@the-village.bc.nu>
Message-ID: <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <20070624200837.16e11305@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-145854784-1182713094=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-145854784-1182713094=:25800
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 24 Jun 2007, Alan Cox wrote:
[..]
> Years ago Linux dumped OSS for ALSA because ALSA offered far better
> functionality and support. Why would we go back to the stone age ?
>
> Its something useful to various other platforms with basically no
> hardware support but Linux has ALSA and very good hardware support and
> ALSA even has emulation for back compatibility with old OSS apps.
>
> Ten years ago it would probably have made a difference, five maybe, today
> its a release of historical code at best, and since they shipped binary
> modules for Linux more like 'getting around to complying with the
> licence' than anything else.

Sory Alan but I don't want philosophical/historical discuss.
Try to answer on question "ALSA or OSS ?" using *only* technical arguments.

Maybe it is not clear for you but now way for introduce better OSS support 
for FOSS applications is completly oppened (there is no legal 
contrargumets fo not using OSS).
There is no ALSA on non-Linux systems (and will not be) so all other 
OSes/Unices will have better sound support than Linux (better on technical 
level and also on support level because all this systems will use 
common OSS) .. and it is only matter of time (when/how fast ?).
If you dont see this please stop ..

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-145854784-1182713094=:25800--
