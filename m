Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYBMUyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYBMUyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYBMUyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:54:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYBMUyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:54:38 -0500
Date: Wed, 13 Feb 2008 12:48:18 -0800
From: Greg KH <greg@kroah.com>
To: Dirk GOUDERS <hank@et.bocholt.fh-gelsenkirchen.de>
Cc: bzolnier@gmail.com, muli@il.ibm.com, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jdmason@kudzu.us, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [discuss] "ide=reverse" do we still need this?
Message-ID: <20080213204818.GA9939@kroah.com>
References: <20080213001506.GA13933@kroah.com> <1237.1202889295@sora.hank.home> <20080213082643.GB14098@kroah.com> <3138.1202932815@sora.hank.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3138.1202932815@sora.hank.home>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 09:00:15PM +0100, Dirk GOUDERS wrote:
> 
> > Hm, so, to summarize:
> >   - you needed this option many years ago to get a box to work properly
> >   - you don't need this today
> > 
> > So, if the option went away, you would not be inconvenienced?
> 
> After having reanimated the old system and after comments of other
> persons I would not be inconvenienced if the option went away.
> 
> The system indeed did not boot correctly without that option, because
> the disks appeared in a wrong order.  On the other hand, I was able to
> (re)install bootloaders (grub as well as lilo) and after that did not
> need the option any more.  Unfortunately, after that I was not able to
> reproduce the initial situation where the option was needed.

Great, thanks a lot for testing this, and letting us know.

greg k-h
