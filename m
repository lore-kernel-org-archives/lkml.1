Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbXEPGwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbXEPGwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXEPGwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:52:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36937 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbXEPGwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:52:14 -0400
Date: Tue, 15 May 2007 23:47:53 -0700
From: Greg KH <greg@kroah.com>
To: Lucy McCoy <lucy@keyspan.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.21] Usb Serial Keyspan: add support for USA-49WG &
	USA-28XG
Message-ID: <20070516064753.GB18729@kroah.com>
References: <464A34F2.5060002@keyspan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464A34F2.5060002@keyspan.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 03:32:18PM -0700, Lucy McCoy wrote:
>  Add support for Keyspan adapters:  USA-49WG and USA-28XG

Yeah!  Thanks for doing this, I was beginning to wonder about these
devices as I had a few users ask about them recently.

>  Signed-off-by: Lucy P. McCoy <lucy@keyspan.com>
>  ---
>  diff -uprN -X linux-2.6.21-vanilla/Documentation/dontdiff 
>  linux-2.6.21-vanilla/drivers/usb/serial/keyspan.c 
>  linux-2.6.21-lpm/drivers/usb/serial/keyspan.c
>  --- linux-2.6.21-vanilla/drivers/usb/serial/keyspan.c    2007-04-25 
>  20:08:32.000000000 -0700
>  +++ linux-2.6.21-lpm/drivers/usb/serial/keyspan.c    2007-05-04 
>  13:35:23.000000000 -0700

Ugh, somehow your email client word-wrapped everything and stripped out
all of the tabs from your patch :(

Can you try resending this to me, and in worse case, as an attachment?

thanks,

greg k-h
