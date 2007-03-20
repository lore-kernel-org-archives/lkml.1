Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbXCTPzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbXCTPzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbXCTPzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:55:14 -0400
Received: from mx1.suse.de ([195.135.220.2]:36995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbXCTPzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:55:13 -0400
Date: Tue, 20 Mar 2007 08:52:59 -0700
From: Greg KH <gregkh@suse.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/31] 2.6.20-stable review
Message-ID: <20070320155259.GC14889@suse.de>
References: <20070319213647.GB9261@kroah.com> <200703200115.05861.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703200115.05861.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 01:15:02AM -0400, Gene Heskett wrote:
> 
> In any event, something tickled the monster, and its hungry.  This is a 
> full-stop, show-stopper AFAIAC.
> 
> I'll cut that patch-2.6.20.4-rc1 in halves, and build 2 more test 
> kernels tomorrow to start a bisect if no one has any better idea 
> before then.

I'd recommend using the quilt tree of patches to do this, it will be
easier than trying to split the larger patch up into pieces by hand.

thanks,

greg k-h
