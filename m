Return-Path: <linux-kernel-owner+w=401wt.eu-S1764167AbXG3Nym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764167AbXG3Nym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbXG3Nyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:54:33 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23347 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760965AbXG3Nyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:54:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAJSKrUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.19,198,1183359600"; 
   d="scan'208"; a="191089504:sNHT23184063"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       general@lists.openfabrics.org, stefan.roscher@de.ibm.com
Subject: Re: [ofa-general] [PATCH 1/2] ehca: remove checkpatch.pl's warnings "externs should be avoided in .c files"
X-Message-Flag: Warning: May contain useful information
References: <200707271254.51055.hnguyen@linux.vnet.ibm.com>
	<adahcnnvpy5.fsf@cisco.com>
	<200707301507.47575.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 30 Jul 2007 06:54:30 -0700
In-Reply-To: <200707301507.47575.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Mon, 30 Jul 2007 15:07:47 +0200")
Message-ID: <adabqdut2sp.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2007 13:54:30.0485 (UTC) FILETIME=[26C53050:01C7D2B1]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Was going to recreate this patch, but then I saw that you
 > probably have incorporated it (manually) in your latest git.
 > Just want to make sure I'm seeing it right.

Yes, I ended up doing it by hand.  Thanks.
