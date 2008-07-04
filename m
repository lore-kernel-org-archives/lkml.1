Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYGDLEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYGDLEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYGDLE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:04:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57012 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751765AbYGDLE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:04:26 -0400
Date: Fri, 4 Jul 2008 11:46:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 4
Message-ID: <20080704114648.13374869@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704195529.7f56e768.sfr@canb.auug.org.au>
References: <20080704195529.7f56e768.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	ttydev: fix pamc_zilog for tty pointer move
> 	ttydev: sparc fix for tty move
> 	ttydev: sparc32 fix for tty move
> 	atmel_serial: Fix tty_port breakage

Got these

> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).

bash-3.2$ git fetch linux-next
remote: error: refs/heads/history does not point to a valid object!
remote: error: refs/heads/master does not point to a valid object!
remote: error: refs/tags/next-20080704 does not point to a valid object!

(on top of a clean current Linus git pull)
