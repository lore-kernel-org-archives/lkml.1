Return-Path: <linux-kernel-owner+w=401wt.eu-S1161461AbXB0AHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161461AbXB0AHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161470AbXB0AHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:07:53 -0500
Received: from mail.kroah.org ([69.55.234.183]:44857 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161459AbXB0AHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:30 -0500
Date: Mon, 26 Feb 2007 16:05:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 0/9] 2.6.19-stable review
Message-ID: <20070227000538.GA6283@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.19.6 release.

This will probably be the last release of the 2.6.19-stable series, so
if there are patches that you feel should be applied to that tree,
please let me know.

There are 9 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday March 1 00:00 UTC.  Anything
received after that time might be too late.

The whole patch set can be downloaded at:
        kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.19.6-rc1.gz

thanks,

the -stable release team
