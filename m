Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYELTLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYELTLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbYELTLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:11:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbYELTLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:11:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Tracking and crediting bug reporters
Date: Mon, 12 May 2008 21:11:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <4388.1210613272@vena.lwn.net>
In-Reply-To: <4388.1210613272@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805122111.36494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 of May 2008, Jonathan Corbet wrote:
> Several members of the Linux Foundation's Technical Advisory Board recently
> got together with Andrew Morton to talk about kernel quality issues.  One
> of the things which came out of that meeting was a desire to improve
> incentives for people who report bugs.  Clearly, actually fixing those bugs
> would qualify; nobody has lost sight of that.  But it was suggested that
> the creation and publication of statistics on bug reporting would also
> help.
> 
> One way to do this might be for Andrew (being the only one who actually
> reads every message posted on the list) to keep a spreadsheet along with
> everything else he does.  That idea did not go over very well.
> 
> So here's what we would like to try instead.  Whenever somebody sends up a
> patch fixing a reported bug, the name of the person who reported the bug
> would be immortalized with this tag:
> 
> 	Reported-by: A. Bug Reporter <email@goes.here>
> 
> In particular, reporters who work with the developers toward the resolution
> of the bug should be thanked in this way.  If we wanted to take things
> further, perhaps we could add a Bisected-by: tag for really hard-core
> helpers. 
> 
> If these tags go into the commit messages in any sort of consistent way, it
> should be possible generate the usual sort of statistics from them.  I'll
> then happily publicize them next to the traditional lists of people who are
> adding new bugs.  The result will certainly be fame, fortune, and job
> offers for the people at the top of the list.  Or something like that.
> 
> If the rest of the community is agreeable, it would be nice to make an
> immediate start on this; it's not yet too late to get reasonable data for
> the 2.6.26 kernel, and to have the habits well ingrained for 2.6.27.
> 
> Thoughts?

I like the idea.

Thanks,
Rafael
