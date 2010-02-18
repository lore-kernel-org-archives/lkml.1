Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab0BRWAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:00:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0BRWAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:00:45 -0500
Date: Thu, 18 Feb 2010 23:00:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: tytso@mit.edu
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] Remove drivers/char/ChangeLog
In-Reply-To: <20100218181753.GJ5337@thunk.org>
Message-ID: <alpine.LNX.2.00.1002182300030.30967@pobox.suse.cz>
References: <20100218095200.63509b8c@bike.lwn.net> <20100218181753.GJ5337@thunk.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010, tytso@mit.edu wrote:

> On Thu, Feb 18, 2010 at 09:52:00AM -0700, Jonathan Corbet wrote:
> > The ChangeLog file under drivers/char is 30K of stuff dedicated to the
> > mid-90's TTY exploits of Ted Ts'o; it has been updated once since 1998
> > - and that was in 2001.  It's interesting history, but we don't
> > normally carry that kind of history inline with the code.  Let's remove
> > it.
> > 
> > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> 
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Applied, thanks.

> Ah, for those good old days when Linus refused to use a SCM (may they
> never return! :-)

Indeed :)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
