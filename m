Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbYBHLo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbYBHLo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYBHLoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:44:46 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36771 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751187AbYBHLop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:44:45 -0500
Date: Fri, 8 Feb 2008 11:38:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Diego Zuccato <diego@otello.alma.unibo.it>
Cc: Lee Mathers <Lee.Mathers@tcafs.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080208113825.4fb10206@core>
In-Reply-To: <47AC191E.303@otello.alma.unibo.it>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D895.20300@davidnewall.com>
	<47A6E742.80408@otello.alma.unibo.it>
	<courier.47A8F072.000079E4@hawking.rebel.net.au>
	<47AAC1EE.6060101@otello.alma.unibo.it>
	<47AB0911.3060508@davidnewall.com>
	<47AB5D2B.5010806@tcafs.org>
	<47AC191E.303@otello.alma.unibo.it>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, winmodem case is the only I could *almost* understand 
> closed-source drivers: the algorithms used *are* the modem. It's not a 
> simple firmware upload.

Winmodem is all about patents, the modem standards come from ISO so are
created by all out corporate warfare with the winner getting the patent
money. Its why we had X2 v 56K, its why they took so long to get anything
done 8)

Graphics interfaces can be very clever and critical to performance. 3Dfx
for example had some very clever register layout tricks to get PCI
bursting of commands.

Personally I wish someone would just get around to putting the basic
rasterising ops (including texture scaling/mapping to 2D plane) into the
CPU. It would be more useful than half of MMX to have a "load
texturepointer, load step and angle, rep textureop" sequence in the CPU


Alan

