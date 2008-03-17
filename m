Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYCQKya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYCQKya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYCQKyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:54:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54863 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752065AbYCQKyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:54:22 -0400
Date: Mon, 17 Mar 2008 10:39:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: david@lang.hm, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080317103927.04eef322@core>
In-Reply-To: <200803170116.19546.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803162252.58274.phillips@phunq.net>
	<alpine.DEB.1.00.0803162341340.14887@asgard.lang.hm>
	<200803170116.19546.phillips@phunq.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So you could potentially connect to a _huge_ disk array and write deltas
> to it.  The disk array would have to support roughly 3 Gbytes/second of
> write bandwidth to keep up with the Violin ramdisk.  Doable, but you are
> now in the serious heavy iron zone.

Mirroring yes, snapshotting no. 

> Personally, I like my nice simple design a lot more.

So we've all noticed

Alan
