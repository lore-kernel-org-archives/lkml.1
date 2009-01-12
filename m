Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZALKDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZALKDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZALKDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:03:34 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:55926 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZALKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:03:33 -0500
Message-ID: <31014a580901120203v593ce9bdn6876263770efbeae@mail.gmail.com>
Date: Mon, 12 Jan 2009 04:03:32 -0600
From: "Mark A. Miller" <mark@mirell.org>
To: "Paul Mundt" <lethal@linux-sh.org>, "Mark A. Miller" <mark@mirell.org>,
       "Bernd Petrovitsch" <bernd@firmix.at>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       "Rob Landley" <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
In-Reply-To: <20090112094121.GD28564@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901020207.30359.rob@landley.net> <495FEEAF.5020005@zytor.com>
	 <200901032006.47652.rob@landley.net>
	 <20090104030619.GA21466@linux-sh.org>
	 <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
	 <1231677939.3517.5.camel@gimli.at.home>
	 <31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com>
	 <20090112082058.GB28564@linux-sh.org>
	 <31014a580901120118u55256b51g448f22e9e0ef5d1f@mail.gmail.com>
	 <20090112094121.GD28564@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 3:41 AM, Paul Mundt <lethal@linux-sh.org> wrote:

> I will repeat, there has not been a single coherent argument against what
> makes perl inherently incapable of being supported.

You're right, this thread is worthless with that particular mindset,
Paul. Not, perhaps that the tool in question is brittle, and prone to
potentially break on more architectures than the current make and C
code infrastructure, no, your stance is, unless Perl *cannot* run on
that particular architecture and environment, it has a valid place in
the kernel because it was chosen by certain developers.

And you're right, I did patch around Perl in order to get it to build
under a MIPSEL uclibc environment.

But yes, this particular thread with you *is* worthless, because it's
an argument who's stance is not worth fighting against because of it's
flawed premise.

-- 
Mark A. Miller
mark@mirell.org
