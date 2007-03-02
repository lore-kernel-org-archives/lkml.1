Return-Path: <linux-kernel-owner+w=401wt.eu-S1423037AbXCBLsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423037AbXCBLsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423041AbXCBLsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:48:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56411 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423037AbXCBLs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:48:26 -0500
Date: Fri, 2 Mar 2007 12:52:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: michal@harddata.com
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Cable detection fixes
Message-ID: <20070302125226.6642c29f@lxorguk.ukuu.org.uk>
In-Reply-To: <20070302063507.GA8345@ellpspace.math.ualberta.ca>
References: <20070301173003.5d5ab4a6@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0703011723270.12485@woody.linux-foundation.org>
	<45E77EDD.3010205@garzik.org>
	<20070302063507.GA8345@ellpspace.math.ualberta.ca>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, I got recently hands on a hardware where 2.6.21-rc1 based
> kernels from Fedora rawhide simply do not boot as there is no
> way to get to disks.  I would not mind some change in behavior
> although so far I can boot at least some earlier kernels.

Doesn't look related at all. Looks like the box you have has chronic IRQ
routing problems.

Alan
