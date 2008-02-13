Return-Path: <linux-kernel-owner+w=401wt.eu-S1763974AbYBMXMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763974AbYBMXMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYBMXMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:12:06 -0500
Received: from baron.borf.com ([12.51.113.4]:28244 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752952AbYBMXMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:12:05 -0500
X-Greylist: delayed 948 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 18:12:04 EST
Date: Wed, 13 Feb 2008 17:56:53 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 aoedev_isbusy()
Message-ID: <20080213225653.GK4355@coraid.com>
References: <20080213213002.GT3383@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0802132303150.29154@fbirervta.pbzchgretzou.qr> <20080213220537.GA24319@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213220537.GA24319@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:05:37AM +0200, Adrian Bunk wrote:
> On Wed, Feb 13, 2008 at 11:03:35PM +0100, Jan Engelhardt wrote:
> > 
> > On Feb 13 2008 23:30, Adrian Bunk wrote:
> > >
> > >This patch #if 0's the no longer used aoedev_isbusy().
> > 
> > Why not just remove it? (It can be resurrected from earlier
> > revisions should it be needed again.)
> 
> I've switched to doing #if 0 instead since this addresses the
> "It might be needed in the future." answer I otherwise sometimes
> got.
> 
> But if a maintainer wants to have such a function deleted instead that's 
> fine with me.

Hello.  That function can go away.  I have some changes pending, but
none of them use aoedev_isbusy.  Thanks for Cc-ing me.

-- 
  Ed L Cashin <ecashin@coraid.com>
