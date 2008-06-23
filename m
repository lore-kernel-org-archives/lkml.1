Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYFWJkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYFWJkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYFWJk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:40:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33334 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753310AbYFWJk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:40:28 -0400
Date: Mon, 23 Jun 2008 10:22:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, wim@iguana.be
Subject: Re: [patch 2/3] WATCHDOG: Clean out header of s3c2410_wdt driver.
Message-ID: <20080623102255.49d602bb@lxorguk.ukuu.org.uk>
In-Reply-To: <20080622230601.GD21835@fluff.org.uk>
References: <20080622213648.343882522@fluff.org.uk>
	<20080622213721.925217733@fluff.org.uk>
	<20080622233516.0a233c61@lxorguk.ukuu.org.uk>
	<20080622230601.GD21835@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> > NAK. This is going to clash with the big pile of changes stuck in the
> > maintainers in queue.
> 
> Then why, as the original driver authour and current maintainer
> do I not get told about this? This isn't the first time I've come
> to apply this sort of thing and find that someone else has slipped
> in an 'trivial' change such as whitespace that breaks an entire
> patch series.

> Do people not bother to check who wrote the driver or who is the
> current maintainer before doing these things?

Yes - and posted patch series to the lists. The entire watchdog tree went
systematically through the cleanup process. Then I've queued a small
series of patches which are a proposed rework of Wim's idea about
changing the API for watchdogs entirely.

It has slipped back out of sight of most people for ages because Wim has
been attending to other things so it has been queued for about 3 weeks.

Alan
