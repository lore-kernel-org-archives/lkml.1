Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbYHLKL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbYHLKL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 06:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYHLKLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 06:11:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49750 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYHLKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 06:11:20 -0400
Date: Tue, 12 Aug 2008 10:30:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -v3 5/7] kexec jump: in sync with hibernation
	implementation
Message-ID: <20080812083053.GA1719@elf.ucw.cz>
References: <1218510873.24951.44.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218510873.24951.44.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-12 11:14:33, Huang Ying wrote:
> Add device_pm_lock() and device_pm_unlock() in kernel_kexec() in sync
> with current hibernation implementation.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
