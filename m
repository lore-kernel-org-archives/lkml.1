Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYHUKER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYHUKER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYHUKEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:04:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45952 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752654AbYHUKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:04:00 -0400
Date: Thu, 21 Aug 2008 10:46:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Lacombe <tuxiko@free.fr>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Subject: Re: EXT3-fs error
Message-ID: <20080821104626.0a10f40c@lxorguk.ukuu.org.uk>
In-Reply-To: <200808211106.39574.tuxiko@free.fr>
References: <200808211106.39574.tuxiko@free.fr>
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

On Thu, 21 Aug 2008 11:06:39 +0200
Eric Lacombe <tuxiko@free.fr> wrote:

> Hi,
> 
> Recently, my computer freezes a lot, and I noted the problems below. I wonder 
> if my hard disk is going die.
> Can someone confirm or infirm my suspicion?

Might be worth running memtest86 on the box overnight and seeing if its
memory or other problems. smartmontools will give you info on the disk
status (as the disk sees it) which can sometimes give clues.

Alan
