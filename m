Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbYFVWwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbYFVWwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbYFVWwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:52:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40397 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754605AbYFVWwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:52:43 -0400
Date: Sun, 22 Jun 2008 23:35:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       wim@iguana.be, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 2/3] WATCHDOG: Clean out header of s3c2410_wdt driver.
Message-ID: <20080622233516.0a233c61@lxorguk.ukuu.org.uk>
In-Reply-To: <20080622213721.925217733@fluff.org.uk>
References: <20080622213648.343882522@fluff.org.uk>
	<20080622213721.925217733@fluff.org.uk>
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

On Sun, 22 Jun 2008 22:36:50 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> Remove the changelog from the top of the driver, which
> is redundant as this information is more accurately
> represented from the revision control holding the
> file.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

NAK. This is going to clash with the big pile of changes stuck in the
maintainers in queue.
