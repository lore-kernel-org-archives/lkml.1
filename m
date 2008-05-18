Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYERJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYERJlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 05:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYERJlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 05:41:12 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51026 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750924AbYERJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 05:41:12 -0400
Subject: Re: [PATCH] spelling of Linus
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jianjun Kong <kongjianjun@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080518084801.GA3081@infradead.org>
References: <12111001012896-git-send-email-kongjianjun@gmail.com>
	 <20080518084801.GA3081@infradead.org>
Content-Type: text/plain
Date: Sun, 18 May 2008 02:41:01 -0700
Message-Id: <1211103661.25754.1.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-05-18 at 04:48 -0400, Christoph Hellwig wrote:
> On Sun, May 18, 2008 at 04:41:41PM +0800, Jianjun Kong wrote:
> > --- a/drivers/serial/mux.c
> > +++ b/drivers/serial/mux.c
> > @@ -356,7 +356,7 @@ static int mux_request_port(struct uart_port *port)
> >   * Perform any autoconfiguration steps for the port.  This function is
> >   * called if the UPF_BOOT_AUTOCONF flag is specified for the port.
> >   * [Note: This is required for now because of a bug in the Serial core.
> > - *  rmk has already submitted a patch to linus, should be available for
> > + *  rmk has already submitted a patch to Linus, should be available
> for

> + *  RMK has already submitted a patch to Linus, should be available
for

Lets also make RMK's initials caps while changing the line.

Cheers,
Sven

