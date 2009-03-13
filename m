Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbZCMUo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbZCMUo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbZCMUoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:44:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:33081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZCMUoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:44:18 -0400
Date: Fri, 13 Mar 2009 13:27:42 -0700
From: Greg KH <gregkh@suse.de>
To: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: How to submit patches that should be considered for stable
	inclusion also [Was: Re: [PATCH v2] x86: mtrr: ...]
Message-ID: <20090313202742.GA26389@suse.de>
References: <20090311150027.GK10490@alberich.amd.com> <200903130942.38568.trenn@suse.de> <20090313091812.GB2571@elte.hu> <200903131108.08619.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903131108.08619.trenn@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 11:08:07AM +0100, Thomas Renninger wrote:
> > Interestingly, the second-ever such tag i found in Git history 
> > was for a fix ... from you:
> I did this more intuitively.
> If this is how it should be done, this info should be spread
> to maintainers and repeated some times until really everybody
> is looking at it.

I've been saying it for quite a while, as well as Andrew, and it's
documented in the Documentation/stable_kernel_rules.txt file.  If you
know of any other way to document this, please let me know.

thanks,

greg k-h
