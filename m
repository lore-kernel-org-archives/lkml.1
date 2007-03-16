Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXCPAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXCPAyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXCPAyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:54:22 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:61710 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbXCPAyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:54:21 -0400
X-Greylist: delayed 1507 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 20:54:21 EDT
Date: Fri, 16 Mar 2007 01:29:12 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andreas =?iso-8859-1?Q?Allg=F6wer?= <andreas.allgoewer@web.de>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>
Subject: Re: sky2 PHY setup
Message-ID: <20070316002912.GB17594@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andreas =?iso-8859-1?Q?Allg=F6wer?= <andreas.allgoewer@web.de>,
	Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>
References: <20070202102705.3cf028a6@freekitty> <20070202210934.GM1693@cip.informatik.uni-erlangen.de> <20070202151601.677ec5d9@freekitty> <20070203073012.GO1693@cip.informatik.uni-erlangen.de> <20070205090429.31d7bd32@freekitty> <20070222193611.GR20035@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222193611.GR20035@cip.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.14 (2007-02-23)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

> yesterday I pulled from Linus tree because I saw the sky2 updated and I
> tried to break it but it seems that my problems are gone. I let you know
> if anything pops up in the future.

bad news. I today tried the sky2 driver which is in Linus Kernel Tree
(HEAD) on a machine with very high network load and it stopped working
without any kernel messages after doing a flawless job under high load
for 5 hours. My watchdog rebooted the machine after 500 seconds. ;-(

        Thomas
