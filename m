Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbXHUGtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbXHUGtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXHUGtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:49:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51438 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbXHUGtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:49:14 -0400
Date: Mon, 20 Aug 2007 23:52:10 -0700
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
Subject: [patch 00/20] 2.6.22-stable review
Message-ID: <20070821065210.GA5275@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.22.5 release.
There are 20 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by August 23 00:00:00 UTC 2007.  Anything
received after that time might be too late.

thanks,

greg k-h
