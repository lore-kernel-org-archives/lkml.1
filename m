Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbZAFWlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbZAFWlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbZAFWiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:38:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33306 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759514AbZAFWiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:38:22 -0500
Date: Tue, 6 Jan 2009 22:38:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       udovdh@xs4all.nl
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090106223804.484f42b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090106223341.GR1474@vanheusden.com>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106223341.GR1474@vanheusden.com>
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

> What are the current problems with this patch? Because especially the
> serial-pps patches are interesting as most users connect their
> gps/atomic clock/etc. to a serial port for their timekeeping.

The pps ldisc code wants redoing differently. I'll sort that once the
rest is merged and it won't take very long.

Alan
