Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbZB0P02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbZB0P02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZB0P0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:26:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59097 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701AbZB0P0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:26:15 -0500
Date: Fri, 27 Feb 2009 15:26:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cedric Roux <sed@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/vcs or /dev/tty local colormap retrieving
Message-ID: <20090227152659.6083b120@lxorguk.ukuu.org.uk>
In-Reply-To: <20354297.220251235744884040.JavaMail.root@spooler2-g27.priv.proxad.net>
References: <20354297.220251235744884040.JavaMail.root@spooler2-g27.priv.proxad.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 3 - have a new ioctl, preferably on /dev/vcsaX
>     or /dev/vcsX, but might also be available
>     for /dev/ttyX (/dev/vcsaX seems more
>     natural, because this device already exports
>     attributes of characters).

This is probably the right approach.
