Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbXKVAwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbXKVAwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbXKVAvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:51:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57294 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbXKVAvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:51:52 -0500
Date: Wed, 21 Nov 2007 16:51:02 -0800
From: Greg KH <greg@kroah.com>
To: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] null pointer dereference during restart autofs (was:
	Linux 2.6.22.12)
Message-ID: <20071122005102.GB25503@kroah.com>
References: <20071105180736.GA28562@kroah.com> <Pine.BSO.4.63.0711210442290.22340@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.BSO.4.63.0711210442290.22340@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 04:45:10AM +0100, Tomasz K?oczko wrote:
>
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 00000014

Did this happen with older versions of 2.6.22.y?

Have you asked the autofs people about this?

thanks,

greg k-h
