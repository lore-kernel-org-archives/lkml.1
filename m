Return-Path: <linux-kernel-owner+w=401wt.eu-S936055AbXGQUtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936055AbXGQUtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936350AbXGQUpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:45:50 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:51008 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936372AbXGQUpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:45:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKLHnEarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,547,1175497200"; 
   d="scan'208"; a="183751104:sNHT24373665"
To: leininger2@llnl.gov
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	<adazm1urji8.fsf@cisco.com> <1184704987.7702.106.camel@hyperion>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 13:45:42 -0700
In-Reply-To: <1184704987.7702.106.camel@hyperion> (Matt Leininger's message of "Tue, 17 Jul 2007 13:43:07 -0700")
Message-ID: <adatzs2pxmx.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2007 20:45:42.0995 (UTC) FILETIME=[715CB230:01C7C8B3]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >      I would like to see these features moved upstream.  DOE funded this
 > work as part of the items we see needing on our large scale IB
 > deployment (both present and future).  So from at least one big customer
 > perspective we see this as useful.  

Does your reference to "present deployment" mean you are running this
code now?

 - R.
