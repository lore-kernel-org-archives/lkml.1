Return-Path: <linux-kernel-owner+w=401wt.eu-S2992908AbXDRWiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992908AbXDRWiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992892AbXDRWiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:38:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58729 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992908AbXDRWiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:38:21 -0400
Date: Wed, 18 Apr 2007 23:41:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/1] Char: tty, add io tty_insert_flip_string variants
Message-ID: <20070418234144.3b183123@the-village.bc.nu>
In-Reply-To: <21144242611885323036@karneval.cz>
References: <21144242611885323036@karneval.cz>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 00:35:20 +0200 (CEST)
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> don't you consider this useful for some drivers. There are many cases, when
> tty_insert_flip_stringio might be used.

I couldn't see anyone who really benefitted when I first looked at this
but if you've got a case you want to use them then I've certainly got no
problem with it.
