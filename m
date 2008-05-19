Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbYESPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbYESPa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbYESPau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:30:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48354 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754265AbYESPat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:30:49 -0400
Date: Mon, 19 May 2008 16:18:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] ip2: Fix crashes on load/unload
Message-ID: <20080519161848.121ae4e8@core>
In-Reply-To: <48319C70.9000207@gmail.com>
References: <20080519132053.578.45185.stgit@core>
	<48319C70.9000207@gmail.com>
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

On Mon, 19 May 2008 17:27:44 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 05/19/2008 03:20 PM, Alan Cox wrote:
> > From: Alan Cox <alan@redhat.com>
> > 
> > This doesn't need to be two modules, and making it one cleans up the
> > problem
> > ---
> > 
> 
> Seems OK, but all your patches misses S-O-F line...

Signed-off-by: Alan Cox <alan@redhat.com> for the watchdog series, tty
series and this fix.

I'll go and have a stern word with the tool management gnome


