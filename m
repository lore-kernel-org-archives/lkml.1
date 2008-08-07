Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYHGMug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYHGMug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYHGMtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:49:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37431 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbYHGMtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:49:50 -0400
Date: Thu, 7 Aug 2008 11:22:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 3/6] kexec jump: remove duplication of kexec_restart_prepare()
Message-ID: <20080807092202.GD372@atrey.karlin.mff.cuni.cz>
References: <1218099928.5164.34.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099928.5164.34.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Call kernel_restart_prepare() in kernel_kexec() instead of duplicating
> the code.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
