Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0BRXnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:43:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:45534 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0BRXnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:43:09 -0500
Date: Fri, 19 Feb 2010 00:43:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Ball <cjb@laptop.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] Remove drivers/char/ChangeLog
In-Reply-To: <20100218233756.18bcc16d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1002190042080.30967@pobox.suse.cz>
References: <20100218095200.63509b8c@bike.lwn.net> <m37hqamlau.fsf@pullcord.laptop.org> <alpine.LNX.2.00.1002182300520.30967@pobox.suse.cz> <20100218233756.18bcc16d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010, Alan Cox wrote:

> > I think we could nuke them all, but I'd suggest first checking with 
> > maintainers of the code in question. It's possible that they do some kind 
> > of auto-import from some weird external repositories in which they 
> > auto-generate this Changelog file, so they might re-appear later (not 
> > everyone is using git even these days ... strange, but apparently true).
> 
> I think I'm the nearest thing to a parport maintainer these days - no
> objection from me there.

Good, thanks. I have queued patch that removes drivers/parport/ChangeLog 
and put 

	Acked-by: Alan Cox <alan@linux.intel.com>

to it.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
