Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbXGaLO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbXGaLO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbXGaLOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:14:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37544 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752759AbXGaLOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:14:21 -0400
Date: Tue, 31 Jul 2007 13:14:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Message-ID: <20070731111435.GB1778@elf.ucw.cz>
References: <1184483593.1898.98.camel@caritas-dev.intel.com> <20070731091004.GA2022@elf.ucw.cz> <1185873924.23149.86.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185873924.23149.86.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This part did not apply for me -- it seems crashdump related and I did
> > not have that applied. Is it critical?
> 
> This is needed for kexec_jump to work properly. Which version of
> kexec-tools do you use? This patch is against 1.101. The kdump patch
> must be applied before this patch is applied.

Ok, did that, got a clean compile, but still could not get it to work.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
