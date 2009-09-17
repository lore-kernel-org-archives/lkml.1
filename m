Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbZIQCMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbZIQCMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbZIQCMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:12:12 -0400
Received: from kroah.org ([198.145.64.141]:46902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbZIQCMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:12:09 -0400
Date: Wed, 16 Sep 2009 19:12:02 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Ken Kawasaki <ken_kawasaki@spring.nifty.jp>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the tty.current tree with the
 net-current tree
Message-ID: <20090917021202.GA7757@kroah.com>
References: <20090917105442.297b6ea1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917105442.297b6ea1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:54:42AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty.current tree got a conflict in
> drivers/serial/serial_cs.c between commit
> 531afd64d027e3d798c416b2b37b3cfb1de417d9 ("pcnet_cs: add cis of Linksys
> multifunction pcmcia card") from the net-current tree and commit
> 5cea4a4e15a918f19d32fd3dc9a5056f333847c3 ("tty: serial/pcmcia: add ID for
> Advantech card") from the tty.current tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.

Thanks, I'll handle this when I sync back up with Linus's tree tomorrow.

greg k-h
