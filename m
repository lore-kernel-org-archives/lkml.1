Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYHTUPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYHTUPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYHTUPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:15:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:47358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbYHTUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:15:29 -0400
Date: Wed, 20 Aug 2008 13:11:06 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: new driver staged in linux1394-2.6.git
Message-ID: <20080820201106.GC10526@kroah.com>
References: <tkrat.51b6249bb700fa85@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.51b6249bb700fa85@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 12:27:40AM +0200, Stefan Richter wrote:
> Hi all,
> 
> just to keep people informed what's in the works:  There are now two new
> branches in the linux1394 git repo,
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv-2.6.27
> 
> This is for preparation of the firesat driver (to be renamed to firedtv
> to better match the corresponding device names) for mainline submission.
> I have harvested the respective patches from Greg KH's staging tree and
> added two further updates; more to be added soon.

Very nice, thanks for picking this up.

Should I drop it from my -staging tree now so that people know to work
off of your version?  This assumes that it will not be dropped by you :)

thanks,

greg k-h
