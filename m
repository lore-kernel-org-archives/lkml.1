Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbXJ2Kr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbXJ2Kr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXJ2Kru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:47:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53669 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXJ2Krt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:47:49 -0400
Date: Mon, 29 Oct 2007 11:47:48 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Markus Elfring <Markus.Elfring@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: No module symbols loaded - kernel modules not enabled.
In-Reply-To: <4725B988.9000806@web.de>
Message-ID: <Pine.LNX.4.64.0710291147290.26070@fbirervta.pbzchgretzou.qr>
References: <fg2p69$t4p$1@ger.gmane.org> <Pine.LNX.4.64.0710282146440.17164@fbirervta.pbzchgretzou.qr>
 <47250092.5070303@web.de> <Pine.LNX.4.64.0710282310370.4125@fbirervta.pbzchgretzou.qr>
 <4725B0F9.4000501@web.de> <Pine.LNX.4.64.0710291109020.26070@fbirervta.pbzchgretzou.qr>
 <4725B988.9000806@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> Like I said, no. This is done by klogd.
>
>Now I have found the notice "Inspecting" in the function "CheckMapVersion".
>http://chuck.netbsd.sk/source/xref/sysklogd-1.4.1rh/ksym.c
>
>I am interested to look at a source file that contains the dicussed error message. Does
>anybody know a development package for the kernel log daemon?

syslogd...src.rpm in your distribution.
