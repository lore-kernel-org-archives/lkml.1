Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbYD3GY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbYD3GY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbYD3GYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:24:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40166 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbYD3GYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:24:11 -0400
Date: Tue, 29 Apr 2008 23:18:33 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: gregkh-02-pci tree is now gone
Message-ID: <20080430061833.GA10573@kroah.com>
References: <20080424225104.GA16529@kroah.com> <20080429223412.0e8f135d.akpm@linux-foundation.org> <20080429.223854.24800777.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429.223854.24800777.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:38:54PM -0700, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 29 Apr 2008 22:34:12 -0700
> 
> > What is gregkh-03-ldp?
> 
> That's the special tree that breaks the linux-next build every day
> in order to make sure Stephen is paying attention :-)

Heh, yeah, that's one description :)

"ldp" -> linuxdriverproject.org

It's a bunch of drivers that are currently under development by the
developers of this project.  Mostly it's drivers that are being cleaned
up and worked into a mergable state, but there are some drivers that are
being built up from scratch there.

Once they are in a mergable state, they then get sent to the proper
subsystem maintainer, but getting this kind of build and run-time
testing is very valuable to have.

thanks,

greg k-h
