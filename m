Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYHIVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYHIVQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYHIVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:16:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38848 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368AbYHIVQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:16:36 -0400
Date: Sat, 9 Aug 2008 21:59:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
Message-ID: <20080809215918.32f25c4b@lxorguk.ukuu.org.uk>
In-Reply-To: <m3skteuhod.fsf@maximus.localdomain>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	<20080808172629.232bed01@lxorguk.ukuu.org.uk>
	<njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	<m3sktfw1v5.fsf@maximus.localdomain>
	<alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
	<20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
	<m3zlnm75u1.fsf@maximus.localdomain>
	<20080809141028.14db9bc7@lxorguk.ukuu.org.uk>
	<m3skteuhod.fsf@maximus.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Even if we do, we can still sort the single driver list
> alphabetically, and we can still "select ATA_SFF" instead of the other
> way around.

That I agree with entirely.

Alan
