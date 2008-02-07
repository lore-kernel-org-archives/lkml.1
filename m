Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbYBGUr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbYBGUr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYBGUrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:47:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759522AbYBGUrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:47:48 -0500
Date: Thu, 7 Feb 2008 12:45:49 -0800
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
Subject: [patch 00/45] 2.6.24-stable review
Message-ID: <20080207204549.GA16389@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.24.1 release.
There are 45 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, Feb 8 2008, 21:00:00 UTC@.
Anything received after that time might be too late.

thanks,

the -stable release team
