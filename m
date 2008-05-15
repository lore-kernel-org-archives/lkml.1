Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYEOICh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYEOICh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYEOICR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:02:17 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:34743 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbYEOICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:02:14 -0400
Message-ID: <010801c8b661$f86e72d0$6400a8c0@bui.materna.com>
From: "Roland" <devzero@web.de>
To: <corbe@lwn.net>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Tracking and crediting bug reporters
Date: Thu, 15 May 2008 10:02:07 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Provags-ID: V01U2FsdGVkX1/sm3DGqRIBECkmW/TT2WcLtAvDBgGf0uuhfqEK
	8Jwwei6nv/hJbcL4VAmmPEhTC6ZJVTTRTqpOaXoBcxG53zRXC0
	MeJsLX14I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 of May 2008, Jonathan Corbet wrote:
> Several members of the Linux Foundation's Technical Advisory Board 
> recently
> got together with Andrew Morton to talk about kernel quality issues.  One
> of the things which came out of that meeting was a desire to improve
> incentives for people who report bugs.  Clearly, actually fixing those 
> bugs
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
> In particular, reporters who work with the developers toward the 
> resolution
> of the bug should be thanked in this way.  If we wanted to take things
> further, perhaps we could add a Bisected-by: tag for really hard-core
> helpers.
>
> If these tags go into the commit messages in any sort of consistent way, 
> it
> should be possible generate the usual sort of statistics from them.  I'll
> then happily publicize them next to the traditional lists of people who 
> are
> adding new bugs.  The result will certainly be fame, fortune, and job
> offers for the people at the top of the list.  Or something like that.
>
> If the rest of the community is agreeable, it would be nice to make an
> immediate start on this; it's not yet too late to get reasonable data for
> the 2.6.26 kernel, and to have the habits well ingrained for 2.6.27.
>
> Thoughts?

very good idea !

anyhow, i`m browsing trough bugzilla for some time and try helping
where i can and there is one thing which is really noticeable:

there are bugreports not being worked on systematically enough and
reporters often don`t feel welcome there.
i saw bug reports which didn`t get a reply for a year or so.
somebody excused for "posting so much" - all he did was posting a
proper description of his problem.

improving of bugzilla handling would be another incentive for bug reporter,
imho.

someone who reports a bug there and never gets a response (not even a formal
"thanks for your report....") will probably never report again.

i have worked for support (software product) some time ago and i
learned one thing there:

there needs to be someone to keep track of the users` input and to keep
track of the developers action/response.

bugreporters forget about their bug if they found a workaround (buying
new hardware or whatever) and developers mostly prefer working on
new code rather than fixing issues. that`s not true for ever user or 
developer,
but if you really want bugs get fixed, someone acting as a mediator is 
essential.
.
regards
roland

