Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbXHFKL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbXHFKL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761805AbXHFKLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:11:20 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41566 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761966AbXHFKLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:11:20 -0400
Date: Mon, 6 Aug 2007 13:11:18 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [2/3] 2.6.23-rc2: known regressions
In-Reply-To: <46B6297C.900@googlemail.com>
Message-ID: <Pine.SOC.4.64.0708061310410.7974@math.ut.ee>
References: <46B5F74D.7010708@googlemail.com> <46B5FA32.50208@googlemail.com>
 <200708051858.12404.rjw@sisk.pl> <46B6297C.900@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Meelis, have you used a "make randconfig" without "make oldconfig"?

No, just usual make ARCH=ppc oldconfig after cg-update.

-- 
Meelis Roos (mroos@linux.ee)
