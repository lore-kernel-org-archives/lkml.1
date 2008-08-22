Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYHVRgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYHVRgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYHVRf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:35:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36913 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750824AbYHVRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:35:59 -0400
Date: Fri, 22 Aug 2008 18:12:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
Subject: Re: build issue #564 for v2.6.27-rc4 : undefined reference to
 `NS8390p_init'
Message-ID: <20080822181234.2f33e993@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0808221025070.6100@shark.he.net>
References: <200808221033.46997.toralf.foerster@gmx.de>
	<Pine.LNX.4.64.0808221025070.6100@shark.he.net>
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

O> > drivers/built-in.o: In function `wd_probe1':
> > wd.c:(.init.text+0x2570): undefined reference to `NS8390p_init'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> Alan,
> 
> Do you have any outstanding patches for these wd (and I've seen
> hp-plus as well IIRC) build issues, or should Jeff have them now?

I'm not really tracking it any more, there were so many patches from so
many people I couldn't give a definitive answer as to what was applied,
is queued or is not queued.

