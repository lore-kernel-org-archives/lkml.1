Return-Path: <linux-kernel-owner+w=401wt.eu-S938214AbXFHReh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938214AbXFHReh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030554AbXFHReM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:34:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35742 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966558AbXFHReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:34:10 -0400
Date: Fri, 8 Jun 2007 10:34:03 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/54] 2.6.21-stable review
Message-ID: <20070608173403.GB10561@kroah.com>
References: <20070608072127.352723000@sous-sol.org> <20070608172852.GP27332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608172852.GP27332@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 01:28:52PM -0400, Dave Jones wrote:
> Or maybe cc: the reviewer list when patches get added?

Oh, we can easily do that as we have a script that notifys the submitter
that the patch has been added.  If you all don't mind getting the noise,
I'd be glad to make that change.

thanks,

greg k-h
