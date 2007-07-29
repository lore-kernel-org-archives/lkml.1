Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbXG2Djp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbXG2Djp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 23:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759894AbXG2DjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 23:39:22 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:39185 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759585AbXG2DjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 23:39:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALKoq0arR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.19,194,1183359600"; 
   d="scan'208"; a="190497986:sNHT22674969"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       general@lists.openfabrics.org, raisch@de.ibm.com,
       stefan.roscher@de.ibm.com
Subject: Re: [PATCH 2/2] ehca: correction include order according kernel coding style
X-Message-Flag: Warning: May contain useful information
References: <200707271255.19456.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 28 Jul 2007 20:39:14 -0700
Message-ID: <adabqdvvpy5.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jul 2007 03:39:15.0033 (UTC) FILETIME=[09087C90:01C7D192]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, I applied this by hand since it was so trivial.
