Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbYGEK2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbYGEK2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYGEK2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:28:05 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:44884 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959AbYGEK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:28:04 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Setting system clock... (FREEZE) (2.6.25.5)
In-reply-to: <alpine.DEB.1.10.0807050430210.14834@p34.internal.lan>
References: <alpine.DEB.1.10.0806100425570.28343@p34.internal.lan> <alpine.DEB.1.10.0807050430210.14834@p34.internal.lan>
Comments: In-reply-to Justin Piszcz <jpiszcz@lucidpixels.com>
   message dated "Sat, 05 Jul 2008 04:31:15 -0400."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 05 Jul 2008 12:27:22 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080705102723.2B5442C400A@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.76
X-Scan-Result: No virus found in message 1KF4zo-0007sj-87.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KF4zo-0007sj-87 655e359dd3a658ae1c9ed23f1b9f7265
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> 
>> http://www.linuxquestions.org/questions/linux-general-1/hard-freeze-on-boot-be
>> tween-setting-clock-and-host-name-625494/ >
> Setting system clock... (FREEZE) > 

I can confirm this as well. hp nc6400 laptop. 
Tripple booting into w2k, sles 10.1 (kernel 2.6.16.xxx afair), and gentoo 
(vanilla 2.6.25.x).

I see the issue on ever 2-4 boots in gentoo only. I'd be happy to try patches.

/Anders


