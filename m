Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0CITuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:50:21 -0500
Received: from kroah.org ([198.145.64.141]:44194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0CITuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:50:19 -0500
Date: Tue, 9 Mar 2010 11:50:09 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: The gregkh patch scripts
Message-ID: <20100309195009.GA18030@kroah.com>
References: <20100307181649.GD3718@kroah.com>
 <Pine.LNX.4.44L0.1003071546000.8502-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003071546000.8502-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 03:54:25PM -0500, Alan Stern wrote:
> On Sun, 7 Mar 2010, Greg KH wrote:
> 
> > Yes, I can switch back to going off of the -rcN-gitM markings that I was
> > using in the past.  If I do that does it make it easier for you?
> > 
> > And yes, you are right, this is a constant rebase, and that's wrong on
> > my part.
> 
> That's exactly the problem.  I don't mind rebasing for each -rcN; in
> fact many of the early -rc kernels often contain important bug fixes so
> I'm glad to have them.  But rebasing more often than that becomes
> increasingly inconvenient.

Ok, I've moved back to the original way I was handling this, it should
all be back to normal now.

thanks,

greg k-h
