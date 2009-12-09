Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZLISUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZLISUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbZLISUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:20:44 -0500
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:62390 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbZLISUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:20:43 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2009 13:20:43 EST
Authentication-Results: rtp-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIB3H0urR7Hu/2dsb2JhbADAVpckhCwE
X-IronPort-AV: E=Sophos;i="4.47,369,1257120000"; 
   d="scan'208";a="73186504"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Linux RDMA <linux-rdma@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: Re: [PATCH resend] ib/ehca: rework destroy_eq()
References: <20091120103213.13b7ba81@alex-laptop>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 09 Dec 2009 10:11:15 -0800
In-Reply-To: <20091120103213.13b7ba81@alex-laptop> (Alexander Schmidt's
	message of "Fri, 20 Nov 2009 10:32:13 +0100")
Message-ID: <ada1vj4t3uk.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Dec 2009 18:11:15.0951 (UTC) FILETIME=[FFA2FFF0:01CA78FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
