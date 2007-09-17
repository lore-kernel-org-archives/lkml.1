Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbXIQUnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbXIQUnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbXIQUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:43:30 -0400
Received: from THUNK.ORG ([69.25.196.29]:54958 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311AbXIQUn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:43:28 -0400
Date: Mon, 17 Sep 2007 16:43:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Claudio Jeker <cjeker@diehard.n-r-g.com>, Adrian Bunk <bunk@kernel.org>,
       "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917204318.GE18360@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Claudio Jeker <cjeker@diehard.n-r-g.com>,
	Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070917125554.GB13179@diehard.n-r-g.com> <20070917133458.GA18360@thunk.org> <20070917192341.GB30119@diehard.n-r-g.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917192341.GB30119@diehard.n-r-g.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 09:23:41PM +0200, Claudio Jeker wrote:
> Because they put their copyright plus license on code that they barely
> modified. If they would have added substantial work into the OpenHAL code
> and by doing that creating something new I would not say much.

Number 1, some of the Linux wireless developers screwed up earlier
versions.  No denying that, the problems were pointed out during the
patch reviewed problem, AND THEY WERE FIXED.

Number 2, if you take a look at their latest set of changes (which
have still not been accepted), the HAL code is under a pure BSD
license (ath5k_hw.c).  Other portions are dual licensed, but not the
HAL --- if people would only take a look at

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=tree;f=drivers/net/wireless;h=2d6caeba0924c34b9539960b9ab568ab3d193fc8;hb=everything

And yet, the BSD folks seem to continue to nurse the above mantra
(which was true, but quickly corrected) combined with the "and the
Linux folks aren't listening", which is manifestly not true.  We might
not agree with everything you are saying, and we might think you're
being highly hypocritical, but we are listening.

> All the comercial code I have ever seen did not do this stunt of adding a
> new copyright and license to barely modified files. Perhaps the "evil"
> companies have more ethics or better understanding of copyright.

In the original BSD 4.3 code, if I recall correctly, /bin/true was 12
lines of AT&T copyright and the standard "this is proprietary
non-published trade secret" legalease with the standard threats of
bazillions and bazillions of damage due to AT&T's irreparable harm if
the file was ever disclosed....  followed by "exit 0".  :-)

Personally, I find that issues of copyright are much more easily
discussed if people keep a sense of balance and humor.  

						- Ted
