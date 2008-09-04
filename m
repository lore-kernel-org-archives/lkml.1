Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYIDLxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYIDLxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYIDLxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:53:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53001 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751922AbYIDLxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:53:42 -0400
Date: Thu, 4 Sep 2008 12:52:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for September 4
Message-ID: <20080904125248.117e7cf9@lxorguk.ukuu.org.uk>
In-Reply-To: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
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

> I have reverted the ttydev tree for today at Andrew's request since it is
> causing him a problem.

I've pushed a "mini" ttydev tree with just the fixes and earlier patches
in for the moment while I nail this one down. That way the stuff which
is independent can still be tested and get to Linus even if the big tty
rework has to be delayed.
