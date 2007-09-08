Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbXIHQrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbXIHQrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbXIHQrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:47:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44255 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753508AbXIHQrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:47:11 -0400
Date: Sat, 8 Sep 2007 17:55:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Howard Chu <hyc@symas.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22.6 pata_via cable detect
Message-ID: <20070908175523.2cc96d10@the-village.bc.nu>
In-Reply-To: <46E2D1D2.9020105@tmr.com>
References: <46DBE1FD.10409@symas.com>
	<46E2D1D2.9020105@tmr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Did you get any off-list feedback on this? I can move a burner back to 
> the VIA to test, but having another controller I took the easy way out 
> and recabled the device. It's production, so I have to test off hours.

There are a couple of fixes just been submitted which may account for
this so for debug its probably best to wait for 2.6.23 with pata_via
cable type bugs or if you want to try the relevant pata_via change.

