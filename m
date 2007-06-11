Return-Path: <linux-kernel-owner+w=401wt.eu-S1763865AbXFKA5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763865AbXFKA5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 20:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760576AbXFKA5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 20:57:34 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:58828 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbXFKA5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 20:57:33 -0400
Date: Mon, 11 Jun 2007 09:56:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Denis Vlasenko <vda.linux@googlemail.com>
Cc: Rene Herman <rene.herman@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO translated into Japanese]
Message-ID: <20070611005613.GA20984@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Denis Vlasenko <vda.linux@googlemail.com>,
	Rene Herman <rene.herman@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@suse.de>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
	linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <20070610175228.GA28947@uranus.ravnborg.org> <466C49DB.6040409@gmail.com> <200706110159.00482.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706110159.00482.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 01:59:00AM +0200, Denis Vlasenko wrote:
> On Sunday 10 June 2007 20:58, Rene Herman wrote:
> > All that stuff only serves to multiply the speed at which a fixed
> > percentage of content obsoletes itself. When it's still new and
> > shiny, sure, stuff will get translated but in no time at all it'll
> > become a fragmented mess which nobody ever feels right about removing
> > because that would be anti-social to all those poor non-english
> > speaking kernel hackers out there.
> 
> I agree. i18n efforts won't help one iota because people just have
> to know English in order to participate in l-k development.

That's a ridiculous statement. Non-native language abilities and
technical competence have very little to do with each other. People have
to understand the code and figure out what it is that they want to
change. As long as this is done cleanly and the intent is obvious,
language doesn't even factor in beyond the Signed-off-by tag. Explanation
is necessary from time to time, but it really depends on the area in
which someone is working. If it's a complicated and involved change, then
of course it takes a bit more effort on both sides, but that doesn't
invalidate the importance or necessity of the work.

> They should be able to read _and_ reply_ to lkml posts,
> and read and understnd code _and_ comments_.
> 
> Those who cannot participate in development because they don't
> know English, won't get much help from some bits of semi-obsolete
> Documentation/* being available. Ok, they will read it, then what?
> How they are supposed to read the code? Write email? etc...
> 
It's arguable whether those that know English well derive any benefit
from semi-obsolete Documentation/* files either. One could speculate that
not being able to read semi-obsolete documentation and being forced to
read the code is actually more productive ;-)

Besides, Kconfig localization is more for the end users than the
developers anyways. I certainly don't see any problem with this, the more
people eyeballing the documentation, the easier it is to find out areas
where we're lacking or that are simply wrong.

> There is only one practical solution: learn the language.
> 
I suggest you step outside of your box and spend more time working with
people who speak little to none of the languages you understand.
