Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbYB0Wsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbYB0Wsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759930AbYB0WsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:48:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46806 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYB0WsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:48:24 -0500
Date: Wed, 27 Feb 2008 14:47:37 -0800
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.24.3
Message-ID: <20080227224737.GC6833@kroah.com>
References: <20080226010024.GA26889@suse.de> <20080225195229.11ec1f12.randy.dunlap@oracle.com> <20080226041545.GA30567@suse.de> <20080227.135959.166225042.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227.135959.166225042.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 01:59:59PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Mon, 25 Feb 2008 20:15:45 -0800
> 
> > > When HEADERS_CHECK=y:
> > > 
> > > make[3]: *** No rule to make target `/local/linsrc/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by `/local/linsrc/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> > > make[2]: *** [linux] Error 2
> > 
> > Is this a regression from 2.6.24.2?  If so, any ideas which patch caused
> > it?
> 
> Greg, look more carefully, it's because of the patch us networking
> folks asked you yesterday to revert.

My appologies, you are correct, tough keeping track of this while at
conferences...

I'll take care of it on Friday.

thanks,

greg k-h
