Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbYLOADW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbYLOADW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 19:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYLOADL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 19:03:11 -0500
Received: from kroah.org ([198.145.64.141]:35089 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751025AbYLOADK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 19:03:10 -0500
Date: Sun, 14 Dec 2008 16:00:11 -0800
From: Greg KH <greg@kroah.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@wizards.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.27.9
Message-ID: <20081215000011.GA5622@kroah.com>
References: <20081214001029.GA915@kroah.com> <pan.2008.12.14.08.06.53.334750@wizards.de> <20081214190829.GA31396@kroah.com> <49456C76.20006@wizards.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49456C76.20006@wizards.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 09:28:38PM +0100, Holger Hoffstätte wrote:
> Greg KH wrote:
> > On Sun, Dec 14, 2008 at 09:06:53AM +0100, Holger Hoffstaette wrote:
> >> On Sat, 13 Dec 2008 16:10:29 -0800, Greg KH wrote:
> >>
> >>> We (the -stable team) are announcing the release of the 2.6.27.9 kernel.
> >> This is still missing the fix for the regression from .7 to .8 that I
> >> reported here:
> >> http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/00006.html
> >>
> >> The fix is here:
> >> http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/00998.html
> >>
> >> Been running that on top of -stable and it does fix the problem. It also
> >> seems to work for other people. Is there some particular reason why this
> >> was not included? I tested and cc'ed stable@ for a reason. :(
> > 
> > The patch is not in Linus's tree yet, right?  That is a requirement to
> > go into the -stable releases.
> 
> It is: http://tinyurl.com/5gpqkj

Ah, missed that, I'll queue it up for the next stable release later this
week.

thanks,

greg k-h
