Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXF0Rzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXF0Rzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbXF0Rzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:55:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42364 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757498AbXF0Rzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:55:39 -0400
Date: Wed, 27 Jun 2007 19:01:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Geode HW Random Number Generator depend on
 X86_3
Message-ID: <20070627190135.66f2c240@the-village.bc.nu>
In-Reply-To: <200706271043.23373.yinghai.lu@sun.com>
References: <200706271043.23373.yinghai.lu@sun.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 10:43:23 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: Geode HW Random Number Generator depend on X86_32
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Acked-by: Alan Cox <alan@redhat.com>

There are no 64bit geode gx series chips
