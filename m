Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbXFYJtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbXFYJtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXFYJs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:48:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:52725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbXFYJs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=T+vFwXw08crvlaWhQM9MNKkYr/jYzrZR8CZbi2o39TaeIOeQBTHP79oIWPWV7jUCmfjLxYJ4MvA7fLAY9iWZbonQpCOs7lS96BTRhV4whcTXUBBtp95bhabITmcB5GPWNSQtXtGxQZOIykc6e6CwfUsR+QZzAHQUW1FHa80N9o0=
Message-ID: <467F8F78.8090700@googlemail.com>
Date: Mon, 25 Jun 2007 11:48:40 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       discuss@x86-64.org, Ioan Ionita <opslynx@gmail.com>
Subject: Re: [1/2] 2.6.22-rc6: known regressions
References: <467F8B35.4010906@googlemail.com>
In-Reply-To: <467F8B35.4010906@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc6.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

*STATISTICS* (a.k.a. list of aces)

Name                    Regressions fixed since 21-Jun-2007
Andi Kleen                             1
Hugh Dickins                           1
Jean Delvare                           1



Sparc64

Subject    : random invalid instruction occourances on sparc32 (sun4c)
References : http://lkml.org/lkml/2007/6/17/111
Submitter  : Mark Fortescue <mark@mtfhpc.demon.co.uk>
Status     : problem is being debugged

Subject    : 2.6.22-rc broke X on Ultra5
References : http://lkml.org/lkml/2007/5/22/78
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Handled-By : David Miller <davem@davemloft.net>
Status     : problem is being debugged



x86-64

Subject    : x86-64 2.6.22-rc2 random segfaults
References : http://lkml.org/lkml/2007/5/24/275
Submitter  : Ioan Ionita <opslynx@gmail.com>
Status     : Unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
