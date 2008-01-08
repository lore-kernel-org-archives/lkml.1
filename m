Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYAHRrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYAHRrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYAHRq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:46:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42599 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYAHRq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:46:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: change SCSI owner in bugzilla
Date: Tue, 8 Jan 2008 18:49:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Martin Bligh <mbligh@mbligh.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Peter Osterlund <petero2@telia.com>
References: <20080106161635.GL2082@does.not.exist> <47839D3C.1090106@mbligh.org> <20080108160607.GA32273@elte.hu>
In-Reply-To: <20080108160607.GA32273@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081849.06846.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of January 2008, Ingo Molnar wrote:
> 
> * Martin Bligh <mbligh@mbligh.org> wrote:
> 
> >>> BTW, would that be possible to forward messages sent to
> >>> power-management_other@kernel-bugs.osdl.org to
> >>> linux-pm@lists.linux-foundation.org?
> >>
> >> stupid question: why isnt this done via what most maintainers do, to 
> >> set up your bugzilla account to generate notifications of the special 
> >> power-management_other@kernel-bugs.osdl.org bugzilla user?
> >
> > That would be better. Creating "users" for mailing lists may be 
> > problematic - if it is, let me know.
> 
> for those who have not set that up yet, it's in:
> 
>   Edit / Prefs / Email Preferences / Users to watch
> 
> add power-management_other@kernel-bugs.osdl.org to that list and you'll 
> be notified about new bugs and changes to existing bugs.

Still, I'd like the list to be notified, not only me (eg. I might be offline or
or unable to respond at the moment, or someone else may know how to fix the
problem).

Thanks,
Rafael
