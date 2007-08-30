Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXH3Jxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXH3Jxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXH3Jxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:53:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34942 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755318AbXH3Jxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:53:31 -0400
Date: Thu, 30 Aug 2007 11:01:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, dex@dragonslave.de
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
Message-ID: <20070830110144.1e8020ec@the-village.bc.nu>
In-Reply-To: <200708300731.20336.a1426z@gawab.com>
References: <200708300731.20336.a1426z@gawab.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Wow!  I have been running 80wire cable detection override on 40wire cables 
> for quite some time without any problem, but I never thought it to be legal 
> if the 40wire cable length is short enough.

Yes.

> How short does it have to be, and can't we have a kernel bootparm to override 
> the cable detection?

For most users the goal should be to automate behaviour. It should just
work.
