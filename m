Return-Path: <linux-kernel-owner+w=401wt.eu-S970235AbXFHSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970235AbXFHSJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969757AbXFHSJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:09:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43951 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970027AbXFHSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:08:59 -0400
Date: Fri, 8 Jun 2007 11:08:41 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/54] 2.6.21-stable review
Message-ID: <20070608180841.GC11870@kroah.com>
References: <20070608072127.352723000@sous-sol.org> <20070608172852.GP27332@redhat.com> <20070608173403.GB10561@kroah.com> <466995CD.8030506@redhat.com> <20070608174729.GA3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608174729.GA3723@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 10:47:29AM -0700, Chris Wright wrote:
> * Chuck Ebbert (cebbert@redhat.com) wrote:
> > Maybe a mailing list for stable-commits could be added, like mm-commits?
> 
> I was thinking the same thing.

Good idea, we can just CC: that list when we commit a patch.

thanks,

greg k-h
