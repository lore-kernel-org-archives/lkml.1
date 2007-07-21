Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbXGUEOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbXGUEOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbXGUEOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:14:31 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:60900 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXGUEOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:14:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CACQloUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,565,1175497200"; 
   d="scan'208"; a="186013828:sNHT20868228"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, raisch@de.ibm.com, stefan.roscher@de.ibm.com,
       fenkes@de.ibm.com
Subject: Re: [PATCH 3/5] ehca: Make ehca2ib_return_code() non-inline
X-Message-Flag: Warning: May contain useful information
References: <200707201602.46415.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 21:14:28 -0700
In-Reply-To: <200707201602.46415.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Fri, 20 Jul 2007 16:02:46 +0200")
Message-ID: <ada3azi75qz.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jul 2007 04:14:28.0972 (UTC) FILETIME=[A1BBFAC0:01C7CB4D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
