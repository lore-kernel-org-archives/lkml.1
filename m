Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZJBSjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZJBSjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZJBSjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:39:37 -0400
Received: from kroah.org ([198.145.64.141]:39826 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbZJBSjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:39:36 -0400
Date: Fri, 2 Oct 2009 11:15:05 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: philipp.reisner@linbit.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, dm-devel@redhat.com,
       zbr@ioremap.net, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/8] SECURITY ISSUE with connector
Message-ID: <20091002181505.GA27118@kroah.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
 <20091002.105659.102583702.davem@davemloft.net>
 <20091002180022.GA22229@kroah.com>
 <20091002.110504.08207839.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002.110504.08207839.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 11:05:04AM -0700, David Miller wrote:
> From: Greg KH <greg@kroah.com>
> Date: Fri, 2 Oct 2009 11:00:22 -0700
> 
> > On Fri, Oct 02, 2009 at 10:56:59AM -0700, David Miller wrote:
> >> All applied to net-2.6, I'll push this out to Linus later
> >> today.
> > 
> > Should it also go to -stable?  If so, I can pick it up once it hits
> > Linus's tree.
> 
> Yes, please take it into -stable.

Will do.

> Greg, I'll also send you a batch of other networking bits
> for -stable later this afternoon as well, just FYI...

Great, I'll queue it up for the next -stable releases, these are full
enough as it is already :)

thanks,

greg k-h
