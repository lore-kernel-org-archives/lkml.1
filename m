Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0BSTOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:14:11 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:5273 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0BSTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:14:09 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMdxfkurR7H+/2dsb2JhbACbCXOlI5dthGcEgxU
X-IronPort-AV: E=Sophos;i="4.49,504,1262563200"; 
   d="scan'208";a="485578056"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Linux RDMA <linux-rdma@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>, of-ewg <ewg@openfabrics.org>
Subject: Re: [PATCH] ib/ehca: fix in_wc handling in process_mad()
References: <20100216095950.15c6eb9d@alex-laptop>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 19 Feb 2010 11:14:05 -0800
In-Reply-To: <20100216095950.15c6eb9d@alex-laptop> (Alexander Schmidt's
	message of "Tue, 16 Feb 2010 09:59:50 +0100")
Message-ID: <adaaav582de.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
