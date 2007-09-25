Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbXIYRf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbXIYRf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbXIYRfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:35:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXIYRfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:35:46 -0400
Date: Tue, 25 Sep 2007 10:35:25 -0700
From: Greg KH <gregkh@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.8, pata_ali issue
Message-ID: <20070925173525.GA32185@suse.de>
References: <20070925062115.GA18444@kroah.com> <6101e8c40709250909x53b44274i17694e64dccae427@mail.gmail.com> <20070925161430.GA14212@suse.de> <Pine.LNX.4.64.0709251858520.945@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709251858520.945@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 07:03:24PM +0200, Jan Engelhardt wrote:
> 
> From my point, sorry for thread hijacking, but I did not have
> the upper node anymore.
> 

How hard is it to start a new message?  Me thinks you need a new email
client :)

> So, here is something that I think should go into the next 2.6.22.
> A proper fix is already in 2.6.23-git-du-jour.

Feel free to send the patch, with the git commit id of the upstream
commit to the stable@kernel.org address and we will be glad to review it
that way.

thanks,

greg k-h
