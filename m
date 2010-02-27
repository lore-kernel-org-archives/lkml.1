Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030919Ab0B0Xhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 18:37:46 -0500
Received: from kroah.org ([198.145.64.141]:55058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030902Ab0B0Xhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 18:37:43 -0500
Date: Sat, 27 Feb 2010 15:37:07 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/5] tty: Add a function to insert a string of
 characters with the same flag
Message-ID: <20100227233707.GA10941@kroah.com>
References: <20100217130604.16008.86393.stgit@localhost.localdomain>
 <20100226221100.GA22352@kroah.com>
 <20100227190212.5958a7d5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100227190212.5958a7d5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 07:02:12PM +0000, Alan Cox wrote:
> On Fri, 26 Feb 2010 14:11:00 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Wed, Feb 17, 2010 at 01:06:30PM +0000, Alan Cox wrote:
> > > The USB drivers often want to insert a series of bytes all with the same
> > > flag set - provide a helper for this case.
> 
> Thats the original set of patches I sent you - there was a second set
> which cleaned up the stuff which leaked from one patch to the next or did
> those vanish into the department of email oblivion somewhere ?

No, I saw them after writing this, and I applied that series instead.
It should all be good now, sorry for the noise.

greg k-h
