Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYHaTHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYHaTHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYHaTHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:07:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1933 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755302AbYHaTHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:07:12 -0400
Date: Sat, 30 Aug 2008 23:57:57 +0200
From: Pavel Machek <pavel@suse.cz>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: Re: [patch] xsave: restore xcr0 during resume
Message-ID: <20080830215757.GA8792@ucw.cz>
References: <20080827215736.GI1152@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827215736.GI1152@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-27 14:57:36, Suresh Siddha wrote:
> Add the missing XCR0(XFEATURE_ENABLED_MASK) restore during resume.
> 
> Reported-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
