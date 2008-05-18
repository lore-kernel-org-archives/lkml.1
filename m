Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYERIsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYERIsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 04:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYERIsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 04:48:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbYERIsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 04:48:03 -0400
Date: Sun, 18 May 2008 04:48:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jianjun Kong <kongjianjun@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spelling of Linus
Message-ID: <20080518084801.GA3081@infradead.org>
References: <12111001012896-git-send-email-kongjianjun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12111001012896-git-send-email-kongjianjun@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 04:41:41PM +0800, Jianjun Kong wrote:
> --- a/drivers/serial/mux.c
> +++ b/drivers/serial/mux.c
> @@ -356,7 +356,7 @@ static int mux_request_port(struct uart_port *port)
>   * Perform any autoconfiguration steps for the port.  This function is
>   * called if the UPF_BOOT_AUTOCONF flag is specified for the port.
>   * [Note: This is required for now because of a bug in the Serial core.
> - *  rmk has already submitted a patch to linus, should be available for
> + *  rmk has already submitted a patch to Linus, should be available for
>   *  2.5.47.]

I'd rather review this comment :)  It needs to be either removed or
totally replaced with one explaining why the patch didn't make it in :)

