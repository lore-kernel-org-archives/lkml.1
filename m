Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbXFXTDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbXFXTDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXFXTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:03:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36628 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751532AbXFXTDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:03:44 -0400
Date: Sun, 24 Jun 2007 20:08:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomasz =?UTF-8?B?S8WCb2N6a28=?= <kloczek@rudy.mif.pg.gda.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070624200837.16e11305@the-village.bc.nu>
In-Reply-To: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 19:51:38 +0200 (CEST)
Tomasz Kłoczko <kloczek@rudy.mif.pg.gda.pl> wrote:

> 
> Few dayas ago OSS source code was oppened uder CDDL for Solaris and GLPv2 
> for Linux:
> 
> http://www.opensound.com/press/2007/oss-gpl-cddl.txt
> 
> So this source without problems code can be integragrated in Linus tree 
> and after this Linux can provide much better soud supoport than 
> with current ALSA.

Years ago Linux dumped OSS for ALSA because ALSA offered far better
functionality and support. Why would we go back to the stone age ?

Its something useful to various other platforms with basically no
hardware support but Linux has ALSA and very good hardware support and
ALSA even has emulation for back compatibility with old OSS apps.

Ten years ago it would probably have made a difference, five maybe, today
its a release of historical code at best, and since they shipped binary
modules for Linux more like 'getting around to complying with the
licence' than anything else.

Alan

