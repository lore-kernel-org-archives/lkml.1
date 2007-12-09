Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXLIVNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXLIVNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXLIVNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:13:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43952 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbXLIVNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:13:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: hibernation issue with kernel 2.6.23-gentoo-r3 at T41
Date: Sun, 9 Dec 2007 22:31:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org
References: <200712031419.41596.toralf.foerster@gmx.de> <200712032254.23656.rjw@sisk.pl> <20071209174108.GH4381@ucw.cz>
In-Reply-To: <20071209174108.GH4381@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712092231.41064.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of December 2007, Pavel Machek wrote:
> On Mon 2007-12-03 22:54:23, Rafael J. Wysocki wrote:
> > On Monday, 3 of December 2007, Toralf Förster wrote:
> > > Hhm,
> > > 
> > > in general it seems to be a regression of kernel 2.6.23 with suspend/hibernate
> > > if a user mode linux image is runnning.
> > > 
> > > With previous kernel versions (tested gentoo-sources-2.6.22-r9 and 
> > > gentoo-sources-2.6.21-r4) I've no problem to either suspend or to hibernate the
> > > ThinkPad T41.
> > > 
> > > However with gentoo-sources-2.6.23-r3 the system didn't neither
> > > suspend nor hibernate. The good news is that the system doesn't hang :-)
> >  
> > Please file a bug report at
> > http://bugzilla.kernel.org/enter_bug.cgi?product=Power%20Management
> > against Hibernation/Suspend and add my address to the report's CC list.
> 
> I smell refrigerator problem; can you suspend if you SIGSTOP your uml,
> first?

That might be, but the issue is apparently fixed in 2.6.24-rc and I'm
struggling to figure out how the !@#$%^ (please see
http://bugzilla.kernel.org/show_bug.cgi?id=9501).

Greetings,
Rafael
