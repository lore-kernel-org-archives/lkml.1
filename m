Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXG2Dja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXG2Dja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 23:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759860AbXG2DjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 23:39:19 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:39185 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580AbXG2DjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 23:39:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALKoq0arR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.19,194,1183359600"; 
   d="scan'208"; a="190497985:sNHT21749580"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       general@lists.openfabrics.org, stefan.roscher@de.ibm.com
Subject: Re: [ofa-general] [PATCH 1/2] ehca: remove checkpatch.pl's warnings "externs should be avoided in .c files"
X-Message-Flag: Warning: May contain useful information
References: <200707271254.51055.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 28 Jul 2007 20:39:14 -0700
Message-ID: <adahcnnvpy5.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jul 2007 03:39:14.0753 (UTC) FILETIME=[08DDC310:01C7D192]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the patch looks fine except your mailer seems to have mangled
it... can you resend so I can apply it?

thanks...
