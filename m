Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab0BNRIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:08:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57529 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0BNRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:08:50 -0500
Date: Sun, 14 Feb 2010 18:07:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Willy Tarreau <w@1wt.eu>, mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214170724.GE1578@ucw.cz>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100213091748.276821e1@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> As a matter of fact, I am advocating the use of xz while I don't have
> it installed on most of my machines. I really don't see this as a
> blocker.

Eh?

Making many people around the world install uncommon tool is not
something that should be done lightly.

> I have an old, slow machine here which I am going to use to perform
> some real world testing, and I'll post the results when I'm done. But I
> suspect that building a kernel on this machine, even a small one with
> just the drivers it needs, will take much longer than unpacking the
> sources. So anyone worrying about performance would rather rely on
> cross-compilation, and in turn can afford whatever decompression tool
> is needed.

On zaurus, kernel compilation takes 4 hours. (I.e. "one night"). So
that one is ... well ... done overnight.

Untar is something I normally wait for, since you need to run
(interactive) oldconfig after that.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
