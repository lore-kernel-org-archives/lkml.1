Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYGUWv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYGUWv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYGUWvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:51:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56853 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308AbYGUWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:51:47 -0400
Date: Mon, 21 Jul 2008 23:34:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix serial_txx9 compile.
Message-ID: <20080721233420.1e8ab13f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080721222702.GA19033@redhat.com>
References: <20080721211659.GA29106@redhat.com>
	<20080721230028.1c7020c9@lxorguk.ukuu.org.uk>
	<20080721222702.GA19033@redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Odd. This breakage happened with the merge in -git8
> Why didn't the associated fixes go along with that merge ?

Because they weren't fully tested against the clashing changes between
the tty tree, firmware and some other cleanups of unidentified origin.

Alan
