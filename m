Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYHGMv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYHGMv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYHGMty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:49:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37400 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbYHGMtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:49:50 -0400
Date: Thu, 7 Aug 2008 11:21:23 +0200
From: Pavel Machek <pavel@suse.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/6] kexec jump: check code size in control page
Message-ID: <20080807092123.GC372@atrey.karlin.mff.cuni.cz>
References: <1218099926.5164.33.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099926.5164.33.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Kexec/Kexec-jump requires code size in control page is less than
> PAGE_SIZE/2. This patch adds runtime checking for this.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
