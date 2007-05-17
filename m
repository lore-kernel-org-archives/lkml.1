Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbXEQSdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbXEQSdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXEQScz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:32:55 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:52382 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXEQScy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:32:54 -0400
X-IronPort-AV: i="4.14,549,1170662400"; 
   d="scan'208"; a="1245947:sNHT17292774"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, raisch@de.ibm.com
Subject: Re: [PATCH 2.6.22] ehca: return proper error code if register_mr fails
X-Message-Flag: Warning: May contain useful information
References: <200705161450.55848.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 17 May 2007 11:32:52 -0700
In-Reply-To: <200705161450.55848.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Wed, 16 May 2007 14:50:55 +0200")
Message-ID: <adar6pfjo6j.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 May 2007 18:32:52.0327 (UTC) FILETIME=[C7468770:01C798B1]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
