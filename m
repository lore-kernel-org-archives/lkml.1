Return-Path: <linux-kernel-owner+w=401wt.eu-S1031108AbXDQP6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031108AbXDQP6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031106AbXDQP6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:58:53 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:15212 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031103AbXDQP6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:58:52 -0400
X-IronPort-AV: i="4.14,419,1170662400"; 
   d="scan'208"; a="412341549:sNHT44825740"
To: CaT <cat@zip.com.au>
Cc: Michael Chan <mchan@broadcom.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Jean-Daniel Pauget <jd@disjunkt.com>
Subject: Re: intermittant petabyte usage reported with broadcom nic
X-Message-Flag: Warning: May contain useful information
References: <20070402014319.GA8345@zip.com.au>
	<20070402001300.3b66007d.akpm@linux-foundation.org>
	<20070402074108.GB8345@zip.com.au> <1176596401.5847.7.camel@dell>
	<1176750651.6217.3.camel@dell> <20070416234348.GF8345@zip.com.au>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Apr 2007 08:58:47 -0700
In-Reply-To: <20070416234348.GF8345@zip.com.au> (cat@zip.com.au's message of "Tue, 17 Apr 2007 09:43:48 +1000")
Message-ID: <ada1wij56x4.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Apr 2007 15:58:47.0812 (UTC) FILETIME=[48B8FC40:01C78109]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I actually have a couple of Dell 1950 systems with bnx2 NICs too,
which I use for kernel development (ie one more crash is fine :)

If someone can give me an idea for what kind of load to use, I can try
this patch out to see if it triggers.

 - R.
