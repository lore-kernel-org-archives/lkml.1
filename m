Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbXB1MFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbXB1MFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932159AbXB1MFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:05:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36301 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932156AbXB1MFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:05:35 -0500
Date: Wed, 28 Feb 2007 13:04:30 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
   be mounted without hanging up the whole system
Message-ID: <20070228130430.78933e67@lxorguk.ukuu.org.uk>
In-Reply-To: <45E4EC08.50409@tmr.com>
References: <20070226180635.GA644@tv-sign.ru>
	<Pine.LNX.4.64.0702261006440.12485@woody.linux-foundation.org>
	<45E3493C.1040706@gmail.com>
	<Pine.LNX.4.64.0702261308490.12485@woody.linux-foundation.org>
	<45E4EC08.50409@tmr.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The bidirectional use is/was PL/IP, aka "laplink" connections. Yes, I 
> still have a machine I installed that way, and it will run 2.2.19 
> forever before I try it again. ;-)

PLIP/Laplink runs bidirectional on ordinary parallel ports. The
bidirectional part of parallel ports in "normal" modes is still used for
things like PnP detection of printer and drivers.
