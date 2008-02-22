Return-Path: <linux-kernel-owner+w=401wt.eu-S936066AbYBVWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936066AbYBVWQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933929AbYBVWKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52555 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934619AbYBVWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:45 -0500
Date: Fri, 22 Feb 2008 14:10:14 -0800
From: Greg KH <greg@kroah.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Alexey Zaytsev <zaytsev.a@protei.ru>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Message-ID: <20080222221014.GB9510@kroah.com>
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de> <47BF0BA4.5060503@googlemail.com> <200802221856.14980.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802221856.14980.mb@bu3sch.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 06:56:14PM +0100, Michael Buesch wrote:
> On Friday 22 February 2008 18:51:32 Gabriel C wrote:
> > > I'm not going to play these kconfig SELECT tricks anymore.
> > 
> > Fix it different then.
> 
> Please do so.
> 
> > Yes it is but that is still not a valid reason to NACK that patch , I'm sorry.
> 
> NACK means I (being the maintainer of the modified code) won't
> sign-off this patch. Nothing more or less. If some upstream maintainer
> decides to bypass me and apply the patch nevertheless is not of
> my business. But I will not sign-off or ack this patch.

As the maintainer will not accept this, I'm not going to take it for the
-stable tree either, sorry.

thanks,

greg k-h
