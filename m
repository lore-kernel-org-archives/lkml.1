Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYANA6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYANA6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 19:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYANA6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 19:58:47 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:34856 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753230AbYANA6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 19:58:46 -0500
Date: Mon, 14 Jan 2008 11:56:24 +1100
From: CaT <cat@zip.com.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.15: kernel processes stuck in D state
Message-ID: <20080114005624.GG3940@zip.com.au>
References: <20080111081233.GB3940@zip.com.au> <4787511A.9050106@s5r6.in-berlin.de> <20080111221516.GD3940@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111221516.GD3940@zip.com.au>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 09:15:16AM +1100, CaT wrote:
> On Fri, Jan 11, 2008 at 12:20:58PM +0100, Stefan Richter wrote:
> > CaT wrote:
> > > Not sure what other info to provide
> > 
> > Is the bug present in 2.6.24-rc7?
> 
> Can't rightly say. I didn't try it before because 2.6.23 fails to
> compile under debian sarge. 2.6.24-rc7 did compile but it has failed to
> come back up. Don't know why as the box is remote (though it wasn't in
> use again yet due to the afore mentioned problems so this is merely an
> annoyance). I'll find out more on Monday.

Ok. Not sure why it didn't boot the first time (black screen) but it
booted the second time. This time both CPUs got initialised and are in
use, no kernel oops during init and no kernel processes stuck in D
state. Should've tried .24 earlier but .23 failed to compile under sarge
due to a buggy binutils so I figured .24 would too.

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
