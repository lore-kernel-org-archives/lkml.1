Return-Path: <linux-kernel-owner+w=401wt.eu-S1030370AbXFHUeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030370AbXFHUeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXFHUeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:34:12 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49498 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbXFHUeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:34:11 -0400
Date: Fri, 8 Jun 2007 13:32:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/54] 2.6.21-stable review
Message-ID: <20070608203244.GP3723@sequoia.sous-sol.org>
References: <20070608072127.352723000@sous-sol.org> <20070608172852.GP27332@redhat.com> <20070608173403.GB10561@kroah.com> <466995CD.8030506@redhat.com> <20070608174729.GA3723@sequoia.sous-sol.org> <20070608180841.GC11870@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608180841.GC11870@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Fri, Jun 08, 2007 at 10:47:29AM -0700, Chris Wright wrote:
> > * Chuck Ebbert (cebbert@redhat.com) wrote:
> > > Maybe a mailing list for stable-commits could be added, like mm-commits?
> > 
> > I was thinking the same thing.
> 
> Good idea, we can just CC: that list when we commit a patch.

OK, stable-commits@vger.kernel.org is set up and ready to roll.
