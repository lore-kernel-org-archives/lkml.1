Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYC2D0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYC2D0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYC2D0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:26:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:53805 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYC2D0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p0TCWtgCjdB/Pw4Ku/fRah31jM0+SKR+s/jdMo5J429whFkKDnztTf4NpWHuesl8BgLGOFkrAz8WAkbEjj9VDDCB1SIhQ97+9yZYpgJmMxzqih9zN+cyHQhZ2lB1WNKtddnnC9QHwX1VYM11GFR35FfWw5mFJNwmb1bF56yC3iQ=
Subject: Re: [PATCH] jbd/jbd2 NULL noise
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080329031843.GJ10722@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk>
	 <1206760526.6543.0.camel@brick> <20080329031843.GJ10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 20:26:36 -0700
Message-Id: <1206761196.6543.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 03:18 +0000, Al Viro wrote:
> On Fri, Mar 28, 2008 at 08:15:26PM -0700, Harvey Harrison wrote:
> > On Sat, 2008-03-29 at 03:07 +0000, Al Viro wrote:
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > ---
> > >  fs/jbd/journal.c  |    4 ++--
> > >  fs/jbd/revoke.c   |    4 ++--
> > >  fs/jbd2/journal.c |   12 ++++++------
> > >  fs/jbd2/revoke.c  |    4 ++--
> > >  4 files changed, 12 insertions(+), 12 deletions(-)
> > > 
> > 
> > I had just about all of fs/ done for this sitting in mm.
> 
> So send it?  I mean, that hardly has a potential to cause breakage - anything
> wrong will be immediately seen on build.

I did, it went into -mm and on Mar 5 it was taken into the subsystem
tree.

Harvey

