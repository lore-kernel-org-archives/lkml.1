Return-Path: <linux-kernel-owner+w=401wt.eu-S937025AbXGTRoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937025AbXGTRoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764147AbXGTRn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:43:57 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:19718 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763733AbXGTRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:43:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAIuQoEarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,563,1175497200"; 
   d="scan'208"; a="185759249:sNHT21695643"
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, jeff@garzik.org, dan.j.williams@intel.com,
       christopher.leech@intel.com, peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH 5/7] I/OAT: Add support for MSI and MSI-X
X-Message-Flag: Warning: May contain useful information
References: <20070720004403.13564.14294.stgit@localhost.localdomain>
	<20070720004512.13564.55742.stgit@localhost.localdomain>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 10:43:26 -0700
In-Reply-To: <20070720004512.13564.55742.stgit@localhost.localdomain> (Shannon Nelson's message of "Thu, 19 Jul 2007 17:45:12 -0700")
Message-ID: <adair8fc6o1.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jul 2007 17:43:26.0661 (UTC) FILETIME=[7A09CF50:01C7CAF5]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

are there any devices that support MSI but not MSI-X?  If not, is
there any point in having code to support both?

 - R.
