Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbYCVCfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbYCVCfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYCVCfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:35:42 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:56339 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYCVCfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:35:41 -0400
To: David Miller <davem@davemloft.net>
Cc: jesper.juhl@gmail.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
X-Message-Flag: Warning: May contain useful information
References: <20080321224250.144333319@sous-sol.org>
	<20080321224333.400857992@sous-sol.org>
	<9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
	<20080321.171401.49157146.davem@davemloft.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Mar 2008 19:35:40 -0700
In-Reply-To: <20080321.171401.49157146.davem@davemloft.net> (David Miller's message of "Fri, 21 Mar 2008 17:14:01 -0700 (PDT)")
Message-ID: <adalk4bv62r.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Mar 2008 02:35:40.0445 (UTC) FILETIME=[6B434CD0:01C88BC5]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > It makes a difference for driver maintainers when users
 > report bugs and we ask them for the version printed
 > by the driver so that we know which fixes have been
 > applied.

I'm not sure if this series of patches really accomplishes that...
you're leaving out some patches such as "[NIU]: Fix 1G PHY link state
handling." that are in the real 0.7.  So the 2.6.24.stable version 0.7
has a different set of fixes than the 2.6.25 version 0.7.

 - R.

