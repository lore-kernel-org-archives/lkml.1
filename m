Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYLIS2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYLIS2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYLIS2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:28:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58379 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753882AbYLIS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:28:06 -0500
Date: Tue, 9 Dec 2008 18:28:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [git patches] libata fixes
Message-ID: <20081209182810.0006dea9@lxorguk.ukuu.org.uk>
In-Reply-To: <200812091825.mB9IPRwq027199@lxorguk.ukuu.org.uk>
References: <20081209055151.GA26498@havoc.gtf.org>
	<200812091825.mB9IPRwq027199@lxorguk.ukuu.org.uk>
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

> Not willing to sound as if I'm nitpicking, but it still has issues with ATAPI DMA on some chipsets and runs with ATAPI DMA disabled by default. Should not it be mentioned somehow?

That and a lot of other information is in the libata wiki.

Alan
