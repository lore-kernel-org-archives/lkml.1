Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbXD1HBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbXD1HBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXD1HBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:01:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbXD1HBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:01:12 -0400
Date: Sat, 28 Apr 2007 00:01:30 -0700
From: Greg KH <gregkh@suse.de>
To: Bryan WU <bryan.wu@analog.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/33] 2.6.20-stable review
Message-ID: <20070428070130.GA8055@suse.de>
References: <20070426165445.GA1898@kroah.com> <1177668954.5969.18.camel@roc-desktop> <20070427151314.GA10281@suse.de> <1177734084.9029.10.camel@roc-desktop> <20070428054800.GA6267@suse.de> <1177742776.9029.17.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177742776.9029.17.camel@roc-desktop>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 02:46:16PM +0800, Bryan WU wrote:
> 
> You know, because the kernel development is so active and so many stable
> versions release, it is very hard to decide use which version for mass
> production, especially some embedded systems which does not often
> upgrade. 

It is difficult.  But you need to just spend the time and test and
verify that the kernel you pick works for your needs.

And then, after choosing that, you need to monitor the newer releases
for bugfixes and security updates that affect your customers, and then
backport them and provide them to your customers in a method by which
they can easily and securely update their machines.

It's not the simplest business to be in, that's for sure, but then
again, it's no different from any other OS provider, except the fact
that we are moving faster, and providing more features and fixes than
anyone ever has before in the history of computing :)

Welcome to the community, if there's anything we can do to help out,
please let us know, we are all in this together for the long haul.

greg k-h
