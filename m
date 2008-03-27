Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYC0Opb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYC0Opb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbYC0OpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:45:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48312 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472AbYC0OpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:45:22 -0400
Date: Thu, 27 Mar 2008 07:45:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080327144505.GB18810@kroah.com>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327183357.7c637aed.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 06:33:57PM +1100, Stephen Rothwell wrote:
> 
> We are up to 49 trees, more are welcome (even if they are currently
> empty).

Can you add my "linux drivers" tree at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-ldp/
to the mix as well?  It should come after my 3 other trees.  It contains
new drivers that are being worked on by the linux driver project group.

The code there isn't the best, but it is actively being worked on to
clean up and get ready for merging, and should always build properly.
If not, I'd like to know about it, as it passes my build tests on i386
and x86-64.

thanks,

greg k-h
