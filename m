Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYE3Qic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYE3Qic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYE3QiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:38:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:40441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYE3QiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:38:21 -0400
Date: Fri, 30 May 2008 09:35:46 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: generic platform driver
Message-ID: <20080530163546.GA19603@suse.de>
References: <20080520092312.GA10745@digi.com> <1211275482-11249-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1211275482-11249-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080520210844.GF3220@local> <20080526055818.GD8791@digi.com> <20080526060247.GA14453@suse.de> <20080530091631.GA1367@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080530091631.GA1367@digi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 11:16:31AM +0200, Uwe Kleine-König wrote:
> Hello Greg,
> 
> Greg KH wrote:
> > On Mon, May 26, 2008 at 07:58:18AM +0200, Uwe Kleine-K?nig wrote:
> > > Hello,
> > > 
> > > Hans J. Koch wrote:
> > > > On Tue, May 20, 2008 at 11:24:42AM +0200, Uwe Kleine-K?nig wrote:
> > > > > Signed-off-by: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
> > > > 
> > > > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> > > I assume now these two patches are ready go into mainline?!  What's the
> > > next step?  Greg, do you take them into your driver tree?
> > 
> > Yes, if everyone has finally agreed, Hans, can you resend them to me so
> > I know what to apply, with you signed-off-by?
> If Hans did that, I didn't notice it.  If you want to take the patches
> from me you can pull them from my uio branch at
> 
> 	git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git uio
> 
> These have the Signed-off-by: by Hans, too.

Hans is at LinuxTag this week and said he would send them to me when he
got back.  So I'll wait for his copies, I'd prefer not to pull from git,
as that doesn't really work well with my patchflow process.

thanks,

greg k-h
