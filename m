Return-Path: <linux-kernel-owner+w=401wt.eu-S964797AbXBNWIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797AbXBNWIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXBNWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:08:09 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:14840 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797AbXBNWII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:08:08 -0500
X-IronPort-AV: i="4.14,170,1170662400"; 
   d="scan'208"; a="464582216:sNHT41893452"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, hch@infradead.org, raisch@de.ibm.com,
       h.carstens@de.ibm.com
Subject: Re: [PATCH 2.6.21-rc1 1/5] ehca: reworked irq handler to avoid/reduce missed irq events
X-Message-Flag: Warning: May contain useful information
References: <200702141740.48286.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 14 Feb 2007 14:08:03 -0800
In-Reply-To: <200702141740.48286.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Wed, 14 Feb 2007 17:40:47 +0100")
Message-ID: <adafy981jgc.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2007 22:08:03.0460 (UTC) FILETIME=[98E81440:01C75084]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine but this patch at least has serious whitespace
damage... please resend a fixed version.

 - R.
