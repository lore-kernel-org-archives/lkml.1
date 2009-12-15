Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZLOIHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZLOIHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbZLOIHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:07:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZLOIHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:07:45 -0500
Date: Tue, 15 Dec 2009 09:07:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: linux-next: origin tree build failure
Message-ID: <20091215080719.GA23630@elte.hu>
References: <20091215164108.45c9d766.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215164108.45c9d766.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/mfd/twl4030-codec.c:29:31: error: linux/i2c/twl4030.h: No such file or directory

FYI, x86 allyesconfig fails to build too so this doesnt only affect PowerPC.

	Ingo
