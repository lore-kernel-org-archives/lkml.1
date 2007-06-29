Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXF2NfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXF2NfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764210AbXF2NfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:35:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59406 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765197AbXF2NfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:35:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Please release a stable kernel Linux 3.0
Date: Fri, 29 Jun 2007 15:41:38 +0200
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, Chuck Ebbert <cebbert@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Zolt?n HUBERT <zoltan.hubert@zzaero.com>, linux-kernel@vger.kernel.org,
       seife@suse.de
References: <200706212349.54983.zoltan.hubert@zzaero.com> <1182469541.2704.13.camel@laptopd505.fenrus.org> <20070628211522.GI5339@ucw.cz>
In-Reply-To: <20070628211522.GI5339@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291541.40188.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 28 June 2007 23:15, Pavel Machek wrote:
> Hi!
> 
> > > >> Even the good ones that get lots of fixes aren't all that good. The
> > > >> biggest problem ATM is that suspend is badly broken and keeps getting
> > > >> worse...
> > > > 
> > > > I wasn't under the impression suspend had really ever worked.  Such a
> > > > messy problem to solve.
> > > > 
> > > 
> > > It never worked reliably for everyone, but with each new release it
> > > seems to get worse.
> > 
> > the thing is just fundamentally not designed right. Declaring it stable
> > ain't gonna fix that. Having someone do a right design (which will
> > obviously will go through some breakage period, even if it's an
> > evolution of the current design) is a required step of getting s/r more
> > reliable... but the current one doesn't get stable just by declaring it
> > so.
> 
> Ok, I guess one more pair of eyes would help.
> 
> 
> > > >> Even the good ones that get lots of fixes aren't all that good. The
> > > >> biggest problem ATM is that suspend is badly broken and keeps getting
> > > >> worse...
> > > > 
> > > > Can you please provide me with any links to suspend-related bug reports from
> > > > you?
> > > 
> > > I get so many suspend/resume bug reports that I've given up trying
> > > to get them fixed. And there are so many bugs that are even worse,
> > > like crashes during normal use, data corruption, etc. that suspend
> > > bugs don't get much attention. But here are the ones for Fedora 6;
> > > the list would be much longer if I included Fedora 5 and 7:
> 
> (list of 20 bugs in redhat bugzilla).
> 
> ...well, it looks a bit better from my side. Number of suspend bugs in
> suse bugzilla is certainly lower, and I guess it works a bit better,
> too. (But we do not claim s2ram support for machines outside of s2ram
> whitelist).
> 
> Now, perhaps redhat should get someone to work on suspend/hibernation
> support (kernel level)? IIRC you had Nigel at one point, but he was
> working on something else?
> 
> Rafael and me am trying to look after hibernation, but I believe noone
> is really working on suspend :-(.

I've been trying to for some time, but I still need to learn more.  Also, the
issues in there are difficult to debug.

Right now I'm collecting information and trying to help where I know what to
do. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
