Return-Path: <linux-kernel-owner+w=401wt.eu-S1763524AbXEZQsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763524AbXEZQsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXEZQr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:47:58 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:46549 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbXEZQr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:47:57 -0400
Date: Sat, 26 May 2007 18:46:31 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Message-ID: <20070526164631.GA2176@electric-eye.fr.zoreil.com>
References: <20070524195616.234280@gmx.net> <200705261750.48816.mb@bu3sch.de> <20070526091309.0af20971.akpm@linux-foundation.org> <200705261820.52240.uwe.bugla@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705261820.52240.uwe.bugla@gmx.de>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla <uwe.bugla@gmx.de> :
> Am Samstag, 26. Mai 2007 18:13 schrieben Sie:
[...]
> > Uwe, http://userweb.kernel.org/~akpm/git-wireless.patch.gz is the current
> > wireless tree.  That's a patch against 2.6.22-rc3.  Could you please test
> > that?  If that works then we know that the bug probably lies outside the
> > b44 driver (or it was subsequently fixed).
> 
> Thank you, Andrew, just wait for a while. I am gonna try.....

Please post the .config and the dmesg for the kernels that you try too.

-- 
Ueimor
