Return-Path: <linux-kernel-owner+w=401wt.eu-S933594AbXHGUm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbXHGUm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXHGUmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:42:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44342 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbXHGUmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:42:20 -0400
Date: Tue, 7 Aug 2007 13:41:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [2.6.22.2 review 00/84] 2.6.22.2 -stable review
Message-ID: <20070807204157.GA23028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So sorry for the delay in getting the .22.y release out, my appologies.
I think I've gotten all the patches that people have sent us, _and_ are
already in Linus's tree.  If you have sent us stuff that I have missed,
please resend.  If you have sent us patches that are not in Linus's tree
yet, please be sure to notify us when they do go into his tree in order
for us to be able to add them to the next review cycle.

This is the start of the stable review cycle for the 2.6.22.2 release.
There are 84 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by August 9, 2007 19:00:00 UTC.  Anything
received after that time might be too late.

thanks,

greg k-h

