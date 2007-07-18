Return-Path: <linux-kernel-owner+w=401wt.eu-S934179AbXGRQUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbXGRQUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760958AbXGRQUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:20:24 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:57146 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759464AbXGRQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:20:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFPanUarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,551,1175497200"; 
   d="scan'208"; a="9222648:sNHT13078716"
To: "Sean Hefty" <sean.hefty@intel.com>
Cc: "'Tziporet Koren'" <tziporet@dev.mellanox.co.il>,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       <general@lists.openfabrics.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [ofa-general] Re: Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <000101c7c957$0e4e51e0$69cc180a@amr.corp.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 18 Jul 2007 09:20:21 -0700
In-Reply-To: <000101c7c957$0e4e51e0$69cc180a@amr.corp.intel.com> (Sean Hefty's message of "Wed, 18 Jul 2007 09:16:52 -0700")
Message-ID: <adasl7llm4a.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2007 16:20:21.0335 (UTC) FILETIME=[89B9EE70:01C7C957]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > We actually use the OFED 1.2 version.  So, this feature is in use, but not this
 > specific implementation.

Hmm... how much testing has the implementation being proposed for
merging actually had?

It might still be OK if the answer is that it hasn't been tested at
scale but that the basic code works and should behave the same as the
code that was tested because the underlying design is the same... is
at least that much true?
