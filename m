Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZBCPPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZBCPPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZBCPPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:15:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbZBCPPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:15:01 -0500
Date: Tue, 3 Feb 2009 16:14:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
Subject: Re: [git pull -tip] headers_check fix cleanup
Message-ID: <20090203151433.GF29046@elte.hu>
References: <1233671617.27322.3.camel@localhost.localdomain> <200902031540.27166.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200902031540.27166.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 03 February 2009, Jaswinder Singh Rajput wrote:
> > These patchset is based on Arnd Bergmann suggestions:
> > git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git core/header-fixes
> > 
> > Jaswinder Singh Rajput (3):
> >       headers_check fix cleanup: linux/coda_psdev.h
> >       headers_check fix cleanup: linux/nubus.h
> >       headers_check fix cleanup: linux/reiserfs_fs.h
> 
> Looks good, thanks for the follow-up!

Pulled into tip:core/header-fixes, thanks guys!

	Ingo
