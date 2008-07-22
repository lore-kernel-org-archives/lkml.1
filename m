Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYGVCYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYGVCYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYGVCYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:24:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57495 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750718AbYGVCYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:24:31 -0400
Date: Tue, 22 Jul 2008 03:06:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix icom serial compile.
Message-ID: <20080722030648.19a382d4@lxorguk.ukuu.org.uk>
In-Reply-To: <18565.15966.954687.565824@cargo.ozlabs.ibm.com>
References: <20080721211659.GA29106@redhat.com>
	<20080721221355.GD3472@redhat.com>
	<20080721230742.4649b94a@lxorguk.ukuu.org.uk>
	<18565.15966.954687.565824@cargo.ozlabs.ibm.com>
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

On Tue, 22 Jul 2008 11:56:46 +1000
Paul Mackerras <paulus@samba.org> wrote:

> Alan Cox writes:
> 
> > On Mon, 21 Jul 2008 18:13:55 -0400
> > Dave Jones <davej@redhat.com> wrote:
> > 
> > > drivers/serial/icom.c: In function 'recv_interrupt':
> > > drivers/serial/icom.c:733: error: 'struct uart_info' has no member named 'tty'
> > > 
> > > Signed-off-by: Dave Jones <davej@redhat.com>
> > 
> > NAK. Already in the ttydev tree but not yet gone to Linus
> 
> Well then why on earth did you send Linus the patch that broke stuff
> in the first place?  That seems like a pretty unfriendly act to me.

See previous replies, apologies to this address.
