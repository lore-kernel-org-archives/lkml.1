Return-Path: <linux-kernel-owner+w=401wt.eu-S935074AbYEBNGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935074AbYEBNGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbYEBNGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:06:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54242 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758584AbYEBNGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:06:37 -0400
Date: Fri, 2 May 2008 13:58:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jan Niklas Hasse" <jhasse@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: libata - DMA problems ICH7 rev 02
Message-ID: <20080502135833.2248900e@core>
In-Reply-To: <8dacd7b30805020437k2390d844ldd8909ebe11e9d56@mail.gmail.com>
References: <8dacd7b30805020437k2390d844ldd8909ebe11e9d56@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> my BIOS didn't support it), but none of them worked (every time my
> harddisk is loading my CPU is spammed with IOWait).

Then you must have a different problem ?

> 
> Output of uname -a and lspci is attached.
> 
> I hope you can help me, very hard to work without DMA. 

Please send the output of "dmesg" after boot


Alan
