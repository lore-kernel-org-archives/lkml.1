Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYLCVK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYLCVK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYLCVKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:10:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35878 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbYLCVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:10:32 -0500
Date: Wed, 3 Dec 2008 21:10:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org, giometti@linux.it
Subject: Re: [PATCH 1/1 #2] Char: n_tty, include module.h
Message-ID: <20081203211032.7dad84e2@lxorguk.ukuu.org.uk>
In-Reply-To: <20081203120643.169baeee.akpm@linux-foundation.org>
References: <1228317711-1311-1-git-send-email-jirislaby@gmail.com>
	<20081203153537.4504bdd7@lxorguk.ukuu.org.uk>
	<20081203120643.169baeee.akpm@linux-foundation.org>
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

> > NAK and NAK the patch needing it.
> 
> Late :(
> 
> > Once PPS is in
> 
> PPS can't go in without this?

PPS stands alone without the tty parts. Once the core PPS bits are
accepted (Ingo seems to be silent on that ?) I'll redo the N_PPS tty
bits.
