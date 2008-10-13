Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbYJMKV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbYJMKV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbYJMKUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:20:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54299 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765693AbYJMKUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:20:46 -0400
Date: Mon, 13 Oct 2008 11:20:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: GIT head no longer boots on x86-64
Message-ID: <20081013112024.0183f982@lxorguk.ukuu.org.uk>
In-Reply-To: <48F31F44.9090507@gmail.com>
References: <20081013102330.46066092@lxorguk.ukuu.org.uk>
	<48F31F44.9090507@gmail.com>
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

On Mon, 13 Oct 2008 12:13:24 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 10/13/2008 11:23 AM, Alan Cox wrote:
> > The boot ends on the first module load with a crash
> > 
> > 	BUG: mm/vmalloc.c 118
> 
> Not 187? 118 is currently a line with `{'. Which git SHA? Is DEBUG_VIRTUAL=y?

Typo sorry - was copying them from across the room - line 188
