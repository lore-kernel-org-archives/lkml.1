Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZJ2Vbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZJ2Vbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZJ2Vbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:31:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbZJ2Vbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:31:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Lutomirski <luto@mit.edu>
Subject: Re: [Bug #14472] EXT4 corruption
Date: Thu, 29 Oct 2009 22:33:11 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Shawn Starr <shawn.starr@rogers.com>, Theodore Tso <tytso@mit.edu>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.haF.Are5KB@chimera> <cb0375e10910291257t1f2f16ciade932bd78689ccc@mail.gmail.com>
In-Reply-To: <cb0375e10910291257t1f2f16ciade932bd78689ccc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910292233.11090.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 October 2009, Andrew Lutomirski wrote:
> On Mon, Oct 26, 2009 at 2:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14472
> > Subject         : EXT4 corruption
> > Submitter       : Shawn Starr <shawn.starr@rogers.com>
> > Date            : 2009-10-13 2:07 (14 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125539997508256&w=4
> > Handled-By      : Theodore Tso <tytso@mit.edu>
> >
> 
> 
> This but is *not* fixed.  I just triggered it a few minutes ago by
> abusing i915 and drm, which caused a panic.  This is slightly newer
> than 2.6.32-rc5, with a couple of i915 bugfixes thrown in.
> 
> Photos are here:
> http://web.mit.edu/luto/www/ext4_crashphotos/
> 
> This is a very nasty regression, for obvious reasons.

Thanks for the update.

Rafael
