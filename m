Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYA1PYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYA1PYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYA1PYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:24:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35324 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYA1PYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:24:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.24 regression: Wake On Lan in sky2 broken on Mac mini
Date: Mon, 28 Jan 2008 16:22:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Tino Keitel <tino.keitel@gmx.de>
References: <20080128002934.GA6354@dose.home.local> <20080128134305.GA31052@dose.home.local> <20080128141241.GA8767@does.not.exist>
In-Reply-To: <20080128141241.GA8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281622.09294.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 of January 2008, Adrian Bunk wrote:
> On Mon, Jan 28, 2008 at 02:43:05PM +0100, Tino Keitel wrote:
> > On Mon, Jan 28, 2008 at 14:37:38 +0100, Mikael Pettersson wrote:
> > 
> > [...]
> > 
> > > However, it _is_ a fact that there is a proliferation of specialized
> > > mailing lists, and it is also a fact that many developers _only_ read
> > > those lists. I'm in no way defending this behaviour, on the contrary
> > > I probably dislike it as much as you do. But we can't ignore it.
> > 
> > I planned to post this to netdev first, but then I thought that it's
> > more a task for the stable team and/or those people who track
> > regressions, and I don't know if those people track all the subsystem
> > mailing lists. Especially as there is a patch that fixes the issue for
> > me, and the corresponding bugzilla entry is alrealy marked as resolved
> > and "patch available", so it seems to me as it is just a matter of
> > incorporating an existing patch into further revisions of 2.6.24.
> 
> If in doubt, send it to both lists.

And CC to the maintainer of the subsystem in question as well as to his
upstream etc. (if you know who they are).

Greetings,
Rafael
