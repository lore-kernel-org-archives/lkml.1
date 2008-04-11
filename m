Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbYDKW6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbYDKW6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 18:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYDKW6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 18:58:48 -0400
Received: from www.tglx.de ([62.245.132.106]:54993 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbYDKW6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 18:58:47 -0400
Date: Sat, 12 Apr 2008 00:58:38 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg KH <greg@kroah.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] UIO: use menuconfig
Message-ID: <20080411225838.GO3185@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410193951.GC3193@local> <20080411213608.GA32522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411213608.GA32522@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 02:36:08PM -0700, Greg KH wrote:
> On Thu, Apr 10, 2008 at 09:39:51PM +0200, Hans J. Koch wrote:
> > On Thu, Apr 10, 2008 at 02:37:01PM +0200, Uwe Kleine-K??nig wrote:
> > > This allows configuring CONFIG_UIO without changing into the UIO submenu
> > 
> > I like it.
> > 
> > Signed-off-by: Hans J Koch <hjk@linutronix.de>
> 
> You like it so much you already acked this same change from someone
> else, which is in my tree at:
> 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver-core/uio-kconfig-improvements.patch
> 
> :)

Hey, I just wanted to improve my Signed-off-by statistics :-) Damn it,
one less...
No, seriously, it looked somehow familiar but I didn't remember. Sorry.

Thanks,
Hans
