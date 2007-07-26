Return-Path: <linux-kernel-owner+w=401wt.eu-S934770AbXGZQjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770AbXGZQjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934205AbXGZQfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:35:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53269 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934316AbXGZQfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:35:07 -0400
Date: Thu, 26 Jul 2007 17:41:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<ukleinek@informatik.uni-freiburg.de>,
       linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
Message-ID: <20070726174150.4ffcabd4@the-village.bc.nu>
In-Reply-To: <46A8CB96.1010501@howardsilvan.com>
References: <46A7FE6A.4030309@howardsilvan.com>
	<20070726123420.GA14163@informatik.uni-freiburg.de>
	<46A8CB96.1010501@howardsilvan.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The manufacturer is using a scope to look for RTS and they're not seeing 
> it, either.  I just use my eyes to look at the LED, but I can see the 
> CTS, DTR, DCD, RD, and TD lights blink, flicker, or dim... (and TD, RD, 
> and CTS tend to go on and off rather quickly).

And you have

1.	The port set up correctly for flow control options in the
kernel ?
2.	Verified that the board vendor remembered to wire it ?
