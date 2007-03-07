Return-Path: <linux-kernel-owner+w=401wt.eu-S965482AbXCGVDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482AbXCGVDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXCGVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:03:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59313 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965482AbXCGVDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:03:36 -0500
Message-ID: <45EF0777.1000202@redhat.com>
Date: Wed, 07 Mar 2007 13:41:59 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 000/101] 2.6.20-stable review
References: <20070307171035.150802805@mini.kroah.org>
In-Reply-To: <20070307171035.150802805@mini.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> After many weeks of backlogs, I've finally flushed out all of the
> pending -stable patches, bringing this series to a whopping 101 patches
> pending for the next 2.6.20.2 release.
> 
> If everyone could please take the time to review them and let me know if
> there are any issues with any of these being applied.
> 
> Also, if there are any patches that I am somehow missing that should go
> into the 2.6.20-stable tree, please forward them on to the
> stable@kernel.org alias.
> 

What happened to jfs_fix_deadlock.patch?

It was there in the git tree and then it was deleted:

 delete mode 100644 queue-2.6.20/jfs_fix_deadlock.patch

