Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYGVB5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYGVB5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 21:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYGVB4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 21:56:54 -0400
Received: from ozlabs.org ([203.10.76.45]:39334 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYGVB4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 21:56:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18565.15966.954687.565824@cargo.ozlabs.ibm.com>
Date: Tue, 22 Jul 2008 11:56:46 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix icom serial compile.
In-Reply-To: <20080721230742.4649b94a@lxorguk.ukuu.org.uk>
References: <20080721211659.GA29106@redhat.com>
	<20080721221355.GD3472@redhat.com>
	<20080721230742.4649b94a@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox writes:

> On Mon, 21 Jul 2008 18:13:55 -0400
> Dave Jones <davej@redhat.com> wrote:
> 
> > drivers/serial/icom.c: In function 'recv_interrupt':
> > drivers/serial/icom.c:733: error: 'struct uart_info' has no member named 'tty'
> > 
> > Signed-off-by: Dave Jones <davej@redhat.com>
> 
> NAK. Already in the ttydev tree but not yet gone to Linus

Well then why on earth did you send Linus the patch that broke stuff
in the first place?  That seems like a pretty unfriendly act to me.

Paul.
