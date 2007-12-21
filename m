Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbXLUORX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbXLUORX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXLUORN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:17:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40208 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbXLUORL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:17:11 -0500
Date: Fri, 21 Dec 2007 14:09:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: Top 10 kernel oopses/warnings for the week of December 21st
 2007
Message-ID: <20071221140934.5f87bf93@the-village.bc.nu>
In-Reply-To: <476BA8AF.4060201@linux.intel.com>
References: <476BA8AF.4060201@linux.intel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Rank 2: uart_flush_buffer
> 	Warning at drivers/serial/serial_core.c:544 in uart_flush_buffer()
> 	Reported 16 times
> 	No specific version information reported; bug present in 2.6.24-rc5
> 	Caused by a bug in the Bluetooth line discipline/tty code

> Rank 7: uart_write
> 	Warning at drivers/serial/serial_core.c:490 in uart_write()
> 	Reported 2 times

Seems to be more of the Bluetooth stuf


Alan
--
	                "DASD is not really IBM - it has a vowel"
                        -Arjan van de Ven
