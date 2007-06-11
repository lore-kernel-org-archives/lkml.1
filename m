Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbXFKIf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbXFKIf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 04:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXFKIfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 04:35:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39308 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbXFKIft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 04:35:49 -0400
Date: Mon, 11 Jun 2007 17:34:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Denis Vlasenko <vda.linux@googlemail.com>
Cc: Rene Herman <rene.herman@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO translated into Japanese]
Message-ID: <20070611083429.GA24145@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Denis Vlasenko <vda.linux@googlemail.com>,
	Rene Herman <rene.herman@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@suse.de>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
	linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <200706110159.00482.vda.linux@googlemail.com> <20070611005613.GA20984@linux-sh.org> <200706110946.11808.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706110946.11808.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 09:46:11AM +0200, Denis Vlasenko wrote:
> On Monday 11 June 2007 02:56, Paul Mundt wrote:
> > That's a ridiculous statement. Non-native language abilities and
> > technical competence have very little to do with each other. People have
> > to understand the code and figure out what it is that they want to
> > change. As long as this is done cleanly and the intent is obvious,
> > language doesn't even factor in beyond the Signed-off-by tag. Explanation
> > is necessary from time to time, but it really depends on the area in
> > which someone is working. If it's a complicated and involved change, then
> > of course it takes a bit more effort on both sides, but that doesn't
> > invalidate the importance or necessity of the work.
> 
> Point me to one person who doesn't know English at all
> and who has successfully participated in l-k devel.
> 
There are entire architectures that have been merged and maintained by
folks who speak little to no english, for example. I'll let you figure
out which ones. Many drivers and such, too. Perhaps you've simply never
noticed since these folks tend not to be terribly vocal.

This is not to say that there aren't communication barriers, but things
do gradually get done in any case.

> I'm not saying that non-English should banned or something.
> In Kconfig it can even make sense. A section on kernel.org
> where people can put translations is also a good idea.
> I can still think that it is almost useless activity,
> but who knows, maybe I'm wrong.
> 
> Just not Documentation/<lang>/* thing and no i18n of printks.

Documentation/* is in enough disarray as it is, I think it's worth having
more people looking at it and verifying that things are up to date and
accurate, regardless of what language they happen to be working in.

Kconfig localization (is is that time of year already?) is another
problem entirely, and one that doesn't have a lot of chance of being kept
up to date. Documentation/* on the other hand isn't terribly prone to
heavy modification, I'd wager most people would rather be lining up to
voluntarily rewrite the floppy driver than even accidentally cd in to
Documentation/. In any event, the rate of change is far lower, and people
at least have a chance of keeping translations updated.

Documentation is one area where we simply suck, the more people working
on it, the better.
