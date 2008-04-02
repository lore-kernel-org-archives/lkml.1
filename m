Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYDBQ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYDBQ0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbYDBQ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:26:28 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10214 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbYDBQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:26:27 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Richard Frank <richard.frank@oracle.com>
Cc: Shirley Ma <mashirle@us.ibm.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, rds-devel@oss.oracle.com
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's in infiniband.git)
References: <adave31bayd.fsf@cisco.com>
	<1207120932.4593.47.camel@localhost.localdomain>
	<aday77w2s5z.fsf@cisco.com> <47F3BE33.4000204@oracle.com>
	<adalk3w2pxz.fsf@cisco.com> <47F3BFEC.1000400@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Apr 2008 09:26:26 -0700
In-Reply-To: <47F3BFEC.1000400@oracle.com> (Richard Frank's message of "Wed,
	02 Apr 2008 12:18:36 -0500")
Message-ID: <ada4pak2pfx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Apr 2008 16:26:26.0947 (UTC) FILETIME=[4CA32530:01C894DE]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Yes, I see this is for pushing RDS upstream - but what about running
 > RDS as is over IWARP NICs - that should just work right ?

No idea.  It depends on whether you took into account the differences
between IB and iWARP.  Anyway that's not really what this thread was about.
