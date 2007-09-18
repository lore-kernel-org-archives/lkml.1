Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbXIRM5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbXIRM5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXIRM5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:57:15 -0400
Received: from THUNK.ORG ([69.25.196.29]:44645 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbXIRM5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:57:14 -0400
Date: Tue, 18 Sep 2007 08:56:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Marco Peereboom <slash@peereboom.us>
Cc: misc@openbsd.org, Claudio Jeker <cjeker@diehard.n-r-g.com>,
       Adrian Bunk <bunk@kernel.org>, "Can E. Acar" <can.acar@pro-g.com.tr>,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070918125647.GH18360@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Marco Peereboom <slash@peereboom.us>, misc@openbsd.org,
	Claudio Jeker <cjeker@diehard.n-r-g.com>,
	Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, linux-kernel@vger.kernel.org,
	Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070917125554.GB13179@diehard.n-r-g.com> <20070917133458.GA18360@thunk.org> <20070917192341.GB30119@diehard.n-r-g.com> <20070917204318.GE18360@thunk.org> <20070918090013.GU32213@nudo.bsws.de> <20070918112947.GA31223@peereboom.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918112947.GA31223@peereboom.us>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 06:29:48AM -0500, Marco Peereboom wrote:
> Now if they'd fix the copyright message to only mention Reyk all would
> be good.

It *does* mention Reyk, if you would bother to look.  The thing which
Theo is kvetching about, and which apparently is enough to cause the
*BSD zombies to start attacking without actually _checking_ _for_
_themselves_ is whether or not Jiri and Nick did enough to work so
they should have their names listed in the headers.  In other words,
all of the megabytes and megabhytes of flamewar is over these two
lines:

> * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
> * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>

Petty, isn't it?  Let's just say it's b.s. like this which is why, 16
years ago, I decided to work with Linux instead of BSD.

						- Ted

P.S.  And yes, before those two lines is:

> * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>

and after those two lines is the BSD permission notice.
