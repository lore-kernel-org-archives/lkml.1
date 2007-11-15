Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbXKOF72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbXKOF72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 00:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbXKOF7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 00:59:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53159 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXKOF7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 00:59:20 -0500
Date: Wed, 14 Nov 2007 21:59:02 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: warning, huge 2.6.23-stable review cycle about to start
Message-ID: <20071115055902.GA4670@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I've been slacking on the -stable front for a bit here, and didn't
realize how far behind I've gotten.  Everyone has been sending patches
in, which is great, but now we are facing a HUGE 114 patch release.

As there's no real way that everyone can review all of these patches,
I've decided to split them up into 6 different categories, and will be
sending patches out in these categories for review.  If people can just
glance over the ones in the areas they care about, I would really
appreciate it.

The 6 categories are:
	- core kernel changes
	- arch specific changes
	- networking changes
	- network driver changes
	- non-network driver changes
	- filesystems

Consider this a warning that your inbox is going to be filled up soon,
so everyone can prepare those filters :)

thanks,

greg k-h
