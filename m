Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbXFMMep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbXFMMep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbXFMMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:34:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46608 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbXFMMeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:34:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: beeping patch for debugging acpi sleep
Date: Wed, 13 Jun 2007 14:40:54 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Leber <christian@leber.de>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070518213701.GA810@core> <1181734353.5012.12.camel@nigel.suspend2.net> <20070613122823.GA2390@elf.ucw.cz>
In-Reply-To: <20070613122823.GA2390@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131440.55285.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 June 2007 14:28, Pavel Machek wrote:
> Hi!
> 
> > > > Ok. I'll take Pavel's silence as agreement too. I'll be a little slow
> > > > (as usual, nowadays!), but will try to get it done next week. I think I
> > > > can in clear conscience do it on Redhat time if I don't manage it
> > > > beforehand.
> > > 
> > > Well, everyone wants it so what can I do... Stefan basically posted 3
> > > liner to do that, and that one will probably work... so just test it.
> > 
> > As he admitted, it's a quick and dirty hack. I'd like to try something
> > nicer.
> 
> Well, his hack + rename one variable and there's one very nice solution.
> 
> > > Oh, and please keep the macro, so it can be moved around .S file for
> > > finding out where it crashes.
> > 
> > Are there other points you'd like to nominate? It would defeat the logic
> > for implementing a nice interface if you still have to recompile your
> > kernel to test beeping in another place.
> 
> Just before entering C would be another interesting point.

Well, x86_64 version would be nice to have too. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
