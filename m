Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYAHRtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYAHRtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYAHRtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:49:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42621 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYAHRtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:49:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: change SCSI owner in bugzilla
Date: Tue, 8 Jan 2008 18:51:54 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Martin Bligh <mbligh@mbligh.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Peter Osterlund <petero2@telia.com>
References: <20080106161635.GL2082@does.not.exist> <20080108160607.GA32273@elte.hu> <200801081849.06846.rjw@sisk.pl>
In-Reply-To: <200801081849.06846.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081851.55387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of January 2008, Rafael J. Wysocki wrote:
> On Tuesday, 8 of January 2008, Ingo Molnar wrote:
> > 
> > * Martin Bligh <mbligh@mbligh.org> wrote:
> > 
> > >>> BTW, would that be possible to forward messages sent to
> > >>> power-management_other@kernel-bugs.osdl.org to
> > >>> linux-pm@lists.linux-foundation.org?
> > >>
> > >> stupid question: why isnt this done via what most maintainers do, to 
> > >> set up your bugzilla account to generate notifications of the special 
> > >> power-management_other@kernel-bugs.osdl.org bugzilla user?
> > >
> > > That would be better. Creating "users" for mailing lists may be 
> > > problematic - if it is, let me know.
> > 
> > for those who have not set that up yet, it's in:
> > 
> >   Edit / Prefs / Email Preferences / Users to watch
> > 
> > add power-management_other@kernel-bugs.osdl.org to that list and you'll 
> > be notified about new bugs and changes to existing bugs.
> 
> Still, I'd like the list to be notified, not only me (eg. I might be offline or
> or unable to respond at the moment, or someone else may know how to fix the
> problem).

Ah, you mean I should create a bugzilla user for the list and add
power-management_other@kernel-bugs.osdl.org to this user's watchlist.  That
will make sense. :-)

Rafael
