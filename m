Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZLMVPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZLMVPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZLMVPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:15:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59851 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754204AbZLMVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:15:11 -0500
Date: Sun, 13 Dec 2009 22:15:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 2/3] staging/dream: add missing include files
Message-ID: <20091213211502.GC5114@elf.ucw.cz>
References: <20091101222717.GB20740@elf.ucw.cz>
 <20091119225602.GC18710@kroah.com>
 <20091120105726.GH11212@elf.ucw.cz>
 <20091120153054.GA23007@kroah.com>
 <20091206215257.GA14137@elf.ucw.cz>
 <20091212190205.GA16364@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212190205.GA16364@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-12-12 11:02:05, Greg KH wrote:
> On Sun, Dec 06, 2009 at 10:52:57PM +0100, Pavel Machek wrote:
> > On Fri 2009-11-20 07:30:54, Greg KH wrote:
> > > On Fri, Nov 20, 2009 at 11:57:26AM +0100, Pavel Machek wrote:
> > > > Where can I get the tree to diff against?
> > > > gregkh-08-staging-2.6.32-rc7-git4.patch just reverts everything.
> > > > 
> > > > I guess I can extract it from
> > > > ://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/series ...
> > > 
> > > Or grab the linux-next tree and branch from right before the "delete the
> > > drivers/staging/dream/ directory" patch.
> > 
> > What is the status here, BTW? staging/dream is still there in git pull
> > from today. Would it be possible to avoid pushing that huge revert to
> > Linus, after all? Fixes are available, and it would be nice to avoid
> > big churn.... Pretty please...
> 
> Sorry for the delay.
> 
> I've pushed out the staging patches for .33, and left in the Dream
> files, as you are trying very hard to get this to work, and to delete
> them now would just be rude of me.  I'll drop the patch from -next that
> removes the files as well when I sync up with Linus later today.
> 
> I'll also work through the patches you have sent me so far that I
> haven't applied, I think there are still a few.
> 
> Hope this helps,

Yep, thanks!

(Things are getting better... slowly. Google now has android/dream
tree based on 2.6.32, and first bits of dream support are being merged...)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
