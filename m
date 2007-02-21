Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbXBUBu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbXBUBu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbXBUBu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:50:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:35739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349AbXBUBuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:50:55 -0500
Date: Tue, 20 Feb 2007 17:49:27 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/18] 2.6.18-stable review
Message-ID: <20070221014927.GA3684@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.18.8 release.

This will be the last release of the 2.6.18-stable series, so if there
are patches that you feel should be applied to that tree, please let me
know.

There are 18 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday February 23 00:00 UTC.  Anything
received after that time might be too late.

The whole patch set can be downloaded at:
        kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.18.8-rc1.gz

thanks,

the -stable release team
