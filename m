Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYHRQ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYHRQ5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYHRQ5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:57:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59124 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752867AbYHRQ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:57:44 -0400
Date: Mon, 18 Aug 2008 17:40:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: douglas.leeder@sophos.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, malware-list@lists.printk.net
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to
 a linux interface for on access scanning
Message-ID: <20080818174036.54285857@lxorguk.ukuu.org.uk>
In-Reply-To: <20080818165432.4E51C3F608D@pmx1.sophos.com>
References: <20080818171500.78590801@lxorguk.ukuu.org.uk>
	<20080818165432.4E51C3F608D@pmx1.sophos.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When you register at Level N, you are excluded from all blocking/scanning 
> at Levels >= N,
> but your ops are still passed to Level < N.

Something like that would do the trick for any simple dependencies yes.

Alan
