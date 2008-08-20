Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbYHTQ5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbYHTQ5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYHTQ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:57:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4892 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753503AbYHTQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:56:59 -0400
Date: Wed, 20 Aug 2008 18:42:12 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/6] Container Freezer: Fix freezer Kconfig
Message-ID: <20080820164212.GA7686@ucw.cz>
References: <20080819232232.432973784@us.ibm.com> <20080819232233.028111599@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819232233.028111599@us.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-19 16:22:33, Matt Helsley wrote:
> kernel/power/Kconfig is not sourced from all architectures but the freezer code
> should be available to all architectures for the cgroup freezer subsystem.
> Sourcing a new kernel/Kconfig.freezer has the added advantage of keeping the
> config definition close to its use in the kernel/Makefile.
> 
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
