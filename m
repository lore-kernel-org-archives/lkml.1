Return-Path: <linux-kernel-owner+w=401wt.eu-S1422772AbXCGR6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422772AbXCGR6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422762AbXCGRNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:13:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:42697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422750AbXCGRNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:31 -0500
Message-Id: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:35 -0800
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
Subject: [patch 000/101] 2.6.20-stable review
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After many weeks of backlogs, I've finally flushed out all of the
pending -stable patches, bringing this series to a whopping 101 patches
pending for the next 2.6.20.2 release.

If everyone could please take the time to review them and let me know if
there are any issues with any of these being applied.

Also, if there are any patches that I am somehow missing that should go
into the 2.6.20-stable tree, please forward them on to the
stable@kernel.org alias.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday March 9, 17:00:00 UTC.  Anything
received after that time might be too late.

thanks,

greg k-h
