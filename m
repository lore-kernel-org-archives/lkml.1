Return-Path: <linux-kernel-owner+w=401wt.eu-S933749AbYBVWfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbYBVWfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYBVWfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:35:10 -0500
Received: from mx1.suse.de ([195.135.220.2]:55042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYBVWfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:35:08 -0500
Date: Fri, 22 Feb 2008 14:32:52 -0800
From: Greg KH <gregkh@suse.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/23] 2.6.22-stable review
Message-ID: <20080222223252.GA19799@suse.de>
References: <20080222213927.GA8686@suse.de> <20080222214416.GA8879@suse.de> <6101e8c40802221403m3f6974a4le09b5c86f6b2ccfd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802221403m3f6974a4le09b5c86f6b2ccfd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:03:02PM +0100, Oliver Pinter wrote:
> ok, thanks, when i find requied patch for 2.6.22.y, then i'm send it.

Hm, no, I really don't want to do a .22 release after this next one.  We
already have a .23 and .24 -stable releases going, I don't have the time
or energy to keep .22 running as well.

It had a nice long life, it's time to just let it go :)

thanks,

greg k-h
