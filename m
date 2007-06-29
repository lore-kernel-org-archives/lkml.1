Return-Path: <linux-kernel-owner+w=401wt.eu-S1762905AbXF2POH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762905AbXF2POH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764936AbXF2PNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:13:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:49160 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763797AbXF2PNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=M/m9hpCjq9J2ZO3qFOYjEN5fytK/u7CM5EFEMNrXZzIciBSO6xQXuzup2m97DWlJ5tNF7CD+ivd59PuIGwBlHEEkYpitZF4bm++k2GgLkn0pCW8LQlQPOfy8nUZf7ud5MLkgAXDq92fGzMCQ7oYRX1n8yDBMhuExG1LtkcqfE2Y=
Message-ID: <46852191.2080506@googlemail.com>
Date: Fri, 29 Jun 2007 17:13:21 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux@horizon.com, Andi Kleen <ak@suse.de>,
       discuss@x86-64.org, Ioan Ionita <opslynx@gmail.com>
Subject: Re: [2/2] 2.6.22-rc6: known regressions v2
References: <46852033.5020708@googlemail.com>
In-Reply-To: <46852033.5020708@googlemail.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc6.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Hugh Dickins                           2
Andi Kleen                             1
Björn Steinbrink                       1
Bjorn Helgaas                          1
Jean Delvare                           1
Olaf Hering                            1
Siddha, Suresh B                       1
Trent Piepho                           1
Ville Syrjälä                          1



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



Suspend

Subject    : Transmeta/APM regression - problems with resume
References : http://lkml.org/lkml/2007/6/27/168
Submitter  : linux@horizon.com
Status     : unknown



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
