Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab0BOPPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:15:36 -0500
Received: from THUNK.ORG ([69.25.196.29]:44735 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0BOPPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:15:34 -0500
Date: Mon, 15 Feb 2010 10:15:22 -0500
From: tytso@mit.edu
To: Jean Delvare <khali@linux-fr.org>
Cc: Pavel Machek <pavel@ucw.cz>, mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100215151522.GI5337@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jean Delvare <khali@linux-fr.org>,
	Pavel Machek <pavel@ucw.cz>, mirrors@kernel.org,
	lasse.collin@tukaani.org,
	linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
	"FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Willy Tarreau <w@1wt.eu>
References: <4B744E13.8040004@kernel.org>
 <20100212150137.648dca7c@hyperion.delvare>
 <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
 <4B75A5DC.3060803@kernel.org>
 <20100212202357.6363d5af@hyperion.delvare>
 <20100212230702.GA10266@1wt.eu>
 <20100213091748.276821e1@hyperion.delvare>
 <20100214170724.GE1578@ucw.cz>
 <20100214200803.4b2348ce@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214200803.4b2348ce@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 08:08:03PM +0100, Jean Delvare wrote:
> On Sun, 14 Feb 2010 18:07:24 +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > As a matter of fact, I am advocating the use of xz while I don't have
> > > it installed on most of my machines. I really don't see this as a
> > > blocker.
> > 
> > Eh?
> > 
> > Making many people around the world install uncommon tool is not
> > something that should be done lightly.
> 
> It's pretty obvious that xz will become popular quickly, at least on
> Linux and BSD systems, much like bz2 is today. I'm not asking people to
> start using ClearCase ;) xz will supersede bz2, it's only a matter of
> time. I see no problem in being one of the early adopters.

If by "quickly" you mean 'ten years', sure, maybe.  Keep in mind that
there are people where who are still using RHEL 3, and some of them
might want to download from ftp.kernel.org.  So those people who are
suggesting that we replace .gz files with .xz on kernel.org are
*really* smoking something good.

People who think xz are good should be working to get it installed by
default into the community and then enterprise distro's, first....

						- Ted
