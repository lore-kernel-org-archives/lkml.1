Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYELRsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYELRsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbYELRs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:48:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:6250 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbYELRsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LYmWpPOjw5excCObfDizpVhWhQIDbIv8HIQTfWaBrFdFyhC963KXjsczQ1I/BMIjCAWgr9OS6lCbzMy5tVBpXwdzRKlCGWy8YC4tIqIKRL4nkui1MAz4kGdSnl18A8OErNkY1wrzOMtMMjCaTdByFul8j5u2U9TXlWdMEDF8YmM=
Date: Mon, 12 May 2008 21:48:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
Message-ID: <20080512174813.GD6913@cvg>
References: <4388.1210613272@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4388.1210613272@vena.lwn.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jonathan Corbet - Mon, May 12, 2008 at 11:27:52AM -0600]
| Several members of the Linux Foundation's Technical Advisory Board recently
| got together with Andrew Morton to talk about kernel quality issues.  One
| of the things which came out of that meeting was a desire to improve
| incentives for people who report bugs.  Clearly, actually fixing those bugs
| would qualify; nobody has lost sight of that.  But it was suggested that
| the creation and publication of statistics on bug reporting would also
| help.
| 
| One way to do this might be for Andrew (being the only one who actually
| reads every message posted on the list) to keep a spreadsheet along with
| everything else he does.  That idea did not go over very well.
| 
| So here's what we would like to try instead.  Whenever somebody sends up a
| patch fixing a reported bug, the name of the person who reported the bug
| would be immortalized with this tag:
| 
| 	Reported-by: A. Bug Reporter <email@goes.here>
| 
| In particular, reporters who work with the developers toward the resolution
| of the bug should be thanked in this way.  If we wanted to take things
| further, perhaps we could add a Bisected-by: tag for really hard-core
| helpers. 
| 
| If these tags go into the commit messages in any sort of consistent way, it
| should be possible generate the usual sort of statistics from them.  I'll
| then happily publicize them next to the traditional lists of people who are
| adding new bugs.  The result will certainly be fame, fortune, and job
| offers for the people at the top of the list.  Or something like that.
| 
| If the rest of the community is agreeable, it would be nice to make an
| immediate start on this; it's not yet too late to get reasonable data for
| the 2.6.26 kernel, and to have the habits well ingrained for 2.6.27.
| 
| Thoughts?
| 
| jon
| 

If my opinion does worth somehow - I'm absolutely agree!

(btw, it seems we forget the main tag ever was - Bug-made-by: ;)

		- Cyrill -
