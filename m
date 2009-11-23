Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZKWTey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZKWTey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZKWTex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:34:53 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:41482 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZKWTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:34:53 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACpzCkurR7H+/2dsb2JhbADAD5cehDwE
X-IronPort-AV: E=Sophos;i="4.47,273,1257120000"; 
   d="scan'208";a="438907914"
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
Date: Mon, 23 Nov 2009 11:34:58 -0800
In-Reply-To: <20091120103213.13b7ba81@alex-laptop> (Alexander Schmidt's
	message of "Fri, 20 Nov 2009 10:32:13 +0100")
Message-ID: <adazl6d2fx9.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Nov 2009 19:34:58.0995 (UTC) FILETIME=[0AFEB030:01CA6C74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > seems like I used your old mail address and I forgot to add the linux-rdma
 > list.

Yes... it didn't go onto patchwork so I missed it.  Will review and
apply, thanks.
