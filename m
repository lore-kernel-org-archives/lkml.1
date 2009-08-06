Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZHFPkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZHFPkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZHFPkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:40:03 -0400
Received: from kroah.org ([198.145.64.141]:60988 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZHFPkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:40:02 -0400
Date: Thu, 6 Aug 2009 08:38:18 -0700
From: Greg KH <greg@kroah.com>
To: Zimmermann Christoph <christoph.zimmermann@bfh.ch>
Cc: Andrew Lutomirski <luto@mit.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Is anyone maintaining (or even using) usbtmc?
Message-ID: <20090806153818.GB27153@kroah.com>
References: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com>
 <8288F66EF13DBA41AD8CBFDA64D8FFA31629782B@nyx.bfh.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8288F66EF13DBA41AD8CBFDA64D8FFA31629782B@nyx.bfh.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 02:19:38PM +0200, Zimmermann Christoph wrote:
> i've asked also some of your questions two month ago.
> 
> i'm a tmc driver user only. i use it to develop my firmware for a
> cypress fx2 based tmc device.
> 
> i've made some bugreporting to greg and to the mailinglist (now i'm not
> sure anymore if all my mails arrived on the mailinglist. the gmame
> archive does not list all mails. the other archives are even worse).
> 
> since then two ore tree small patches are sent to the mailinglist. but
> none seemed to adress my bugs (one patch was about a memory leak)
> 
> > If the answer is no (as I suspect it is), then I might give fixing it
> > a shot the week after next, when I'll be camping out in Virginia with
> > this thing for awhile.  In that case, I have another question:
> 
> do it. greg is the maintainer of the whole usb stuff and is working
> really hard. so i understand that he only has little time on "our"
> usbtmc bugs. in my opionion it's good when you do it to help greg with
> it. he still is the maintainer and has to sign of your patches.

Yes, any patches you can provide for this driver would be most
appreciated.

> the other thing is, that i belive, please correct me, that greg don't
> has an usbtmc device to test with. for me it seems that there is lack
> of testing in the usbtmc driver. thats why i assume this.

No, I do have a device, I just don't really have a userspace program to
strongly stress it :)

thanks,

greg k-h
