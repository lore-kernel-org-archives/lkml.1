Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYGUWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYGUWZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYGUWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:25:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33223 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbYGUWZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:25:06 -0400
Date: Mon, 21 Jul 2008 23:07:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix icom serial compile.
Message-ID: <20080721230742.4649b94a@lxorguk.ukuu.org.uk>
In-Reply-To: <20080721221355.GD3472@redhat.com>
References: <20080721211659.GA29106@redhat.com>
	<20080721221355.GD3472@redhat.com>
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

On Mon, 21 Jul 2008 18:13:55 -0400
Dave Jones <davej@redhat.com> wrote:

> drivers/serial/icom.c: In function 'recv_interrupt':
> drivers/serial/icom.c:733: error: 'struct uart_info' has no member named 'tty'
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

NAK. Already in the ttydev tree but not yet gone to Linus

Alan
