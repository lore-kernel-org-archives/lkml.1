Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZLRWca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZLRWca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZLRWc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:32:28 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:49685 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZLRWc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:32:27 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADeRK0urR7H+/2dsb2JhbAC/K5cghC4E
X-IronPort-AV: E=Sophos;i="4.47,420,1257120000"; 
   d="scan'208";a="281515740"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Simon Horman <horms@verge.net.au>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kexec\@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: kexec reboot broken with ioatdma?
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
	<20091216224912.GC16219@verge.net.au>
	<aday6l27c7w.fsf@roland-alpha.cisco.com> <4B296930.9020704@intel.com>
	<adatyvq7bbi.fsf@roland-alpha.cisco.com>
	<1261174241.16958.6.camel@dwillia2-linux.ch.intel.com>
	<adafx773ox9.fsf@roland-alpha.cisco.com>
	<1261175000.16958.8.camel@dwillia2-linux.ch.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 18 Dec 2009 14:32:25 -0800
In-Reply-To: <1261175000.16958.8.camel@dwillia2-linux.ch.intel.com> (Dan
	Williams's message of "Fri, 18 Dec 2009 15:23:20 -0700")
Message-ID: <adabphv3ocm.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Dec 2009 22:32:25.0670 (UTC) FILETIME=[F93C1E60:01CA8031]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > What was that, all of 8 minutes to turn that test around! :-) Nice.

Well, a kexec reboot takes < 30 seconds, and this is a *very* fast box,
so rebuilding the kernel is another 30 seconds.  So I was really just
slacking off for about 7 of those minutes :)

 - R.
