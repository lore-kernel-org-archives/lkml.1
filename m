Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbXIHM7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbXIHM7w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 08:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXIHM7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 08:59:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36821 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXIHM7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 08:59:44 -0400
Date: Sat, 8 Sep 2007 15:01:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Thomas Voegtle <tv@lio96.de>, Soeren Sonnenburg <kernel@nn7.de>,
       Christian Leber <christian@leber.de>,
       kbuild-devel@lists.sourceforge.net,
       Roman Zippel <zippel@linux-m68k.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [4/4] 2.6.23-rc5: known regressions v2
Message-ID: <20070908130104.GA23408@uranus.ravnborg.org>
References: <46E27DEF.7060109@googlemail.com> <46E2835E.9010408@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E2835E.9010408@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal.

> Kconfig/Kbuild
> 
> Subject         : building a specific in-tree module is currently a bit broken
> References      : http://lkml.org/lkml/2007/9/5/40
> Last known good : ?
> Submitter       : Robert P. J. Day <rpjday@mindspring.com>
> Caused-By       : ?
> Handled-By      : Sam Ravnborg <sam@ravnborg.org>
> Status          : problem is being debugged

Known bug there has been there for ages so this is not a regression.
I suggest removing it from this list - and I will see to have
it fixed for 2.6.24.
I will not push any fix for -rc for this.

	Sam
