Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZIHXGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZIHXGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZIHXGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:06:11 -0400
Received: from kroah.org ([198.145.64.141]:59003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZIHXGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:06:10 -0400
Date: Tue, 8 Sep 2009 16:04:16 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, stable-review@kernel.org,
       linux-kernel@vger.kernel.org, stable-review@linux.kernel.org
Subject: Re: 2.6.27 maintenance plans after 2.6.32 is released
Message-ID: <20090908230416.GA8283@kroah.com>
References: <43e72e890909081230h420c2abi125a6fbfc2777250@mail.gmail.com>
 <43e72e890909081244m4083a1bcq30cf1306ce566726@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890909081244m4083a1bcq30cf1306ce566726@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 12:44:23PM -0700, Luis R. Rodriguez wrote:
> On Tue, Sep 8, 2009 at 12:30 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> > I was curious if 2.6.27 is planned to be supported after 2.6.32 is
> > released, or will that be dropped in favor for 2.6.28 as the last
> > supported kernel. How does dropping an old kernel for stable
> > maintenance consideration typically work?

.27 is a "long term" support kernel that I've decided to keep going for
a variety of reasons.  .28 and .29 are currently no longer maintained.

So .27 is "special" right now, and seems to be working well.  I keep
revaluating if it's worth keeping going, and so far, it seems like it
is, if for nothing else, personal reasons as I have a few servers based
on it :)

For .30, we will probably do a few more releases once .31 is out, and
then drop it as well.

I'm confused as to what .32 has to do with any of this, that's months
away...

thanks,

greg k-h
