Return-Path: <linux-kernel-owner+w=401wt.eu-S935509AbXGQSGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935509AbXGQSGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934306AbXGQSGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:06:42 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17009 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761865AbXGQSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:06:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAPOhnEarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,546,1175497200"; 
   d="scan'208"; a="183667026:sNHT24672960"
To: Shirley Ma <xma@us.ibm.com>
Cc: general@lists.openfabrics.org, general-bounces@lists.openfabrics.org,
       linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: Re: [ofa-general] Re: Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <OFCB3C6CBA.79B1F6B5-ON87257317.00675CD3-88257317.00675C91@us.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 11:06:39 -0700
In-Reply-To: <OFCB3C6CBA.79B1F6B5-ON87257317.00675CD3-88257317.00675C91@us.ibm.com> (Shirley Ma's message of "Fri, 13 Jul 2007 11:50:54 -0700")
Message-ID: <ada4pk2sy4w.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2007 18:06:39.0586 (UTC) FILETIME=[390C0C20:01C7C89D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >         We are working on IPoIB to use multiple EQ for multiple 
 > links/connetions scalability. Does this mean this will wait for 2.6.24?

I think so -- I don't want to merge something that first appears in
the last few days of the merge window.  The idea is to get your stuff
queued up *before* the merge window opens.

 - R.
