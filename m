Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYDJJIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYDJJIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYDJJIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:08:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2483 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754274AbYDJJIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:08:05 -0400
Date: Wed, 9 Apr 2008 11:34:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080409093444.GA6957@ucw.cz>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204773188.4707.109.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is a minimal patch with only the essential features. All
> additional features are split out and can be discussed later. I think
> it may be easier to get consensus on this minimal patch.


Eric, can we get some reviewing/merging going on? Patches seem pretty
clean to me, and I do not think holding them outside mainline will
help them... they will only get bigger and harder to merge :-(.

> Now, only the i386 architecture is supported. The patchset is based on
> Linux kernel 2.6.25-rc3-mm1, and has been tested on IBM T42 with ACPI
> on and off.
> 
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
