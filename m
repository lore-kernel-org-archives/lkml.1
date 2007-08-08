Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbXHHQIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbXHHQIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXHHQIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:08:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:24038 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762802AbXHHQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:08:26 -0400
X-IronPort-AV: i="4.19,236,1183359600"; 
   d="scan'208"; a="196517105:sNHT42649497"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, stefan.roscher@de.ibm.com,
       paulus@samba.org, general@lists.openfabrics.org
Subject: Re: [PATCH] ehca: map 4k firmware context of cq, qp to user space
X-Message-Flag: Warning: May contain useful information
References: <200708021139.31695.hnguyen@linux.vnet.ibm.com>
	<adawswd3ayo.fsf@cisco.com>
	<200708031036.20859.hnguyen@linux.vnet.ibm.com>
	<200708081613.39837.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 08 Aug 2007 09:08:20 -0700
In-Reply-To: <200708081613.39837.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Wed, 8 Aug 2007 16:13:39 +0200")
Message-ID: <ada3ayuqaa3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Aug 2007 16:08:20.0959 (UTC) FILETIME=[570606F0:01C7D9D6]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Haven't got any ack for this updated patch yet. Anyway, since it contains
 > another bug as shown below, please ignore this patch. We'll send a patch 
 > set that includes the proper version of this patch later.

Yes, sorry, I'm a bit behind applying patches.

Anyway, OK I'll wait for a fixed patch and drop this one :)
