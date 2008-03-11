Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbYCKPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbYCKPc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYCKPcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:32:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:46000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbYCKPcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:32:48 -0400
Date: Tue, 11 Mar 2008 08:28:33 -0700
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PATCH] USB suspend persistance for 2.6.25-rc5 git
Message-ID: <20080311152833.GA25380@suse.de>
References: <20080311004239.GD17890@suse.de> <20080311102746.GA31701@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311102746.GA31701@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 11:27:46AM +0100, Pavel Machek wrote:
> 
> Hi!
> 
> > A few -rc releases ago you asked about USB storage devices being
> > persistant across suspend/resume cycles.
> > 
> > Well, Alan Stern has put together a nice small set of patches that do
> > just this.  Here they are against your 2.6.26-rc5-git tree.
> > 
> > Now I know they are a new "feature" and it's way late in the release
> > cycle, but you were asking for this a while ago.  I've been beating on
> > it with my laptops and had no problems at all.
> 
> I'd really prefer this to go to 2.6.26-rc1. This screams like "needs a
> lot of testing" patch.

Well, it looks like Linus decided to defer to that release.

Which is fine, I'll put it in the openSUSE kernel now as I think it is
ready for users to use :)

thanks,

greg k-h
