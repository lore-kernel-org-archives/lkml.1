Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYG2JKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYG2JKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYG2JKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:10:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45729 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245AbYG2JKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:10:22 -0400
Date: Tue, 29 Jul 2008 09:51:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasily Averin <vvs@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Vasily Averin <vvs@sw.ru>
Subject: Re: [PATCH]: Proposed fix to the I2O problems with > 4GB space
Message-ID: <20080729095122.7021ddd0@lxorguk.ukuu.org.uk>
In-Reply-To: <488ED4CF.1000402@parallels.com>
References: <20080725131637.48072ef3@lxorguk.ukuu.org.uk>
	<20080729004756.113d85a0.akpm@linux-foundation.org>
	<488ED4CF.1000402@parallels.com>
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

> One of our test nodes uses i2o controller. Now this node have 6 Gb memory and
> quite a long time it works well under 64-bit RHEL5-based kernel. I'm not sure is
> i2o card really 64-bit capable, but dmesg shows that it uses 64-bit dma.

Do you use the i2o config interfaces and driver ?

