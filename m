Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbXLDXfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbXLDXfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 18:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXLDXf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 18:35:29 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46148 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbXLDXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 18:35:28 -0500
Date: Tue, 4 Dec 2007 23:27:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Subject: Re: [PATCH 1/3] drivers/char/tty_io.c: remove pty_sem
Message-ID: <20071204232737.09c7c38f@the-village.bc.nu>
In-Reply-To: <20071204215003.291002606@mvista.com>
References: <20071204215003.291002606@mvista.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 00:00:01 -0800
Daniel Walker <dwalker@mvista.com> wrote:

> I couldn't find any users, so removing it..
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>

Acked-by: Alan Cox <alan@redhat.com>
