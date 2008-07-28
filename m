Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYG1WDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYG1WDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbYG1WCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:02:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37431 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756486AbYG1WCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:02:40 -0400
Date: Mon, 28 Jul 2008 22:45:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove drivers/serial/v850e_uart.c
Message-ID: <20080728224514.36d6ad05@lxorguk.ukuu.org.uk>
In-Reply-To: <20080728214353.GF7713@cs181140183.pp.htv.fi>
References: <20080728214353.GF7713@cs181140183.pp.htv.fi>
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

On Tue, 29 Jul 2008 00:43:53 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> The removal of drivers/serial/v850e_uart.c originally was in my v850 
> removal patch, but it seems it got lost somewhere.
> 
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
