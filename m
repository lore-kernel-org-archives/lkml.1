Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbXITIRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbXITIRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761815AbXITIP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:15:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37334 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761800AbXITIP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:15:26 -0400
Date: Thu, 20 Sep 2007 10:15:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 2/2 -mm] kexec based hibernation -v3: kexec restore
Message-ID: <20070920081524.GA8732@atrey.karlin.mff.cuni.cz>
References: <1190266450.21818.18.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190266450.21818.18.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds writing support for /dev/oldmem. This is used to
> restore the memory contents of hibernated system.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

ACK. (And this can even go in before the patch #1, right?)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
