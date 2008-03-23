Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYCWEUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYCWEUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 00:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYCWEU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 00:20:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:51589 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYCWEUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 00:20:25 -0400
To: David Miller <davem@davemloft.net>
Cc: jesper.juhl@gmail.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
X-Message-Flag: Warning: May contain useful information
References: <20080321.171401.49157146.davem@davemloft.net>
	<adalk4bv62r.fsf@cisco.com>
	<20080321.222125.245725675.davem@davemloft.net>
	<20080322.154627.54355549.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 22 Mar 2008 21:20:22 -0700
In-Reply-To: <20080322.154627.54355549.davem@davemloft.net> (David Miller's message of "Sat, 22 Mar 2008 15:46:27 -0700 (PDT)")
Message-ID: <adar6e2t6k9.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Mar 2008 04:20:22.0620 (UTC) FILETIME=[3624E1C0:01C88C9D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Actually Roland, that 1G fix you mention was put in during the
 > 2.6.23 development series.
 > 
 > If you ask git for all the NIU driver changes since 2.6.24
 > you get:

Sorry for the noise... I did

    git log cb77df3e..a4425859 drivers/net/niu.c

to get all the niu changes between when you bumped the version to 0.6
and when you bumped it to 0.7.  I didn't think to check which post-0.6
changes were already in 2.6.24.

As long as the version helps you out, I guess it's all good.

 - R.
