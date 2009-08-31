Return-Path: <linux-kernel-owner+w=401wt.eu-S1751362AbZHaV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbZHaV0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 17:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZHaV0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 17:26:03 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:23096 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZHaV0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 17:26:02 -0400
X-IronPort-AV: E=Sophos;i="4.44,307,1249257600"; 
   d="scan'208";a="186724524"
From: Roland Dreier <rdreier@cisco.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Hal Rosenstock <hnrose@comcast.net>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Construct MAD redirect replies from request MAD
References: <200908261337.56128.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 31 Aug 2009 14:25:59 -0700
In-Reply-To: <200908261337.56128.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Wed, 26 Aug 2009 13:37:55 +0200")
Message-ID: <adaeiqrpteg.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Aug 2009 21:26:00.0184 (UTC) FILETIME=[A2AC7780:01CA2A81]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this seems reasonable to me, applied, thanks.
