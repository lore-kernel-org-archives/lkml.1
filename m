Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYGUWSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYGUWSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYGUWRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:17:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59025 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750794AbYGUWRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:17:55 -0400
Date: Mon, 21 Jul 2008 23:00:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, alan@redhat.com
Subject: Re: Fix serial_txx9 compile.
Message-ID: <20080721230028.1c7020c9@lxorguk.ukuu.org.uk>
In-Reply-To: <20080721211659.GA29106@redhat.com>
References: <20080721211659.GA29106@redhat.com>
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

On Mon, 21 Jul 2008 17:16:59 -0400
Dave Jones <davej@redhat.com> wrote:

> drivers/serial/serial_txx9.c: In function 'receive_chars':
> drivers/serial/serial_txx9.c:275: error: 'struct uart_info' has no member named 'tty'

Already fixed ages ago. Its in a patch that didn't get to Linus yet - see
the linux-next tree for the stuff pending.
