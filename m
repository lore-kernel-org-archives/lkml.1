Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZDURdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZDURdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZDURd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:33:28 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:61857 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbZDURd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:33:27 -0400
X-IronPort-AV: E=Sophos;i="4.40,225,1238976000"; 
   d="scan'208";a="174735490"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, Roland Dreier <rolandd@cisco.com>,
       raisch@de.ibm.com, fenkes@de.ibm.com, alexschm@de.ibm.com,
       stefan.roscher@qde.ibm.com, hnguyen@de.ibm.com
Subject: Re: [PATCH 0/3] IB/ehca: Perfomance improvment for creation of queue pairs
References: <200904211715.32625.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 21 Apr 2009 10:33:24 -0700
In-Reply-To: <200904211715.32625.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Tue, 21 Apr 2009 17:15:32 +0200")
Message-ID: <ada1vrlx66z.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2009 17:33:24.0865 (UTC) FILETIME=[4620C710:01C9C2A7]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Because of this fundamental code change we will also increment the version number.

So this is 2.6.31-targeted stuff I assume?  (Too late in the 2.6.30
cycle for "fundamental code change" of course)

 - R.
