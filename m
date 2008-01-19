Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYASXuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYASXuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYASXtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:49:50 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34437 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbYASXtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:49:50 -0500
Date: Sat, 19 Jan 2008 23:48:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: "Lars Callenbach" <lars.callenbach@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: linux device ordering at boot time
Message-ID: <20080119234804.3c58c77b@lxorguk.ukuu.org.uk>
In-Reply-To: <200801200007.00125.hpj@urpla.net>
References: <20080119185520.208350@gmx.net>
	<200801200007.00125.hpj@urpla.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, it's a major pain in the a**. I've no idea, what reversed the order of 
> PCI devices, but I had to disable the automatic dvb driver loading in order 

It depends on the order you load the modules

Alan
