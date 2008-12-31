Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYLaQ7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYLaQ7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYLaQ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:59:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46621 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753443AbYLaQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:59:39 -0500
Date: Wed, 31 Dec 2008 16:59:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan De Luyck <ml_linuxkernel_20080830@kcore.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28 - cannot find root fs on Acer TM 291 (ICH4-M)
Message-ID: <20081231165945.3a97f316@lxorguk.ukuu.org.uk>
In-Reply-To: <495B9CC9.5080507@kcore.org>
References: <495B5ABD.7040909@kcore.org>
	<18779.24723.646720.252479@harpo.it.uu.se>
	<495B9CC9.5080507@kcore.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are there any real benefits to switching to libata? Except ofcourse, more
> uptodate, being actively developed on, ... ;)

The main ones are support for newer chipsets, NCQ (multiple commands at a
time) and hot-plug SATA.

Alan
