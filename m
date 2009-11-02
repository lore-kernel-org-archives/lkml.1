Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZKBTOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZKBTOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbZKBTOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:14:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52169 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755766AbZKBTOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:14:31 -0500
Date: Mon, 2 Nov 2009 19:16:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Alan Cox <alan@linux.intel.com>, linux-mmc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, dhowells@redhat.com
Subject: Re: [PATCH 0/6] Clean up the sdio_uart driver and fix the tty code
Message-ID: <20091102191604.010acbc9@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0911021243040.13333@xanadu.home>
References: <20091102164039.11877.88825.stgit@localhost.localdomain>
	<alpine.LFD.2.00.0911021243040.13333@xanadu.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However I have problems applying your patches.  Most of them require 
> fuzzy patching to apply, and one of them even doesn't apply that way.  
> What is your base tree?

Linux-next, but there is a patch I posted afterwards that goes before the
sdio_uart patches. Want me to send you a set with all the patches
including the other one ?
