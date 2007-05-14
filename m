Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXENUmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXENUmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXENUmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:42:17 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39641 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbXENUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:42:15 -0400
X-IronPort-AV: i="4.14,532,1170662400"; 
   d="scan'208"; a="421850564:sNHT44365528"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 6/6] IB/ehca: disable scaling code by default, bump version number
X-Message-Flag: Warning: May contain useful information
References: <200705091348.31742.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 14 May 2007 13:42:08 -0700
In-Reply-To: <200705091348.31742.fenkes@de.ibm.com> (Joachim Fenkes's message of "Wed, 9 May 2007 13:48:31 +0200")
Message-ID: <adatzufuogv.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 May 2007 20:42:09.0009 (UTC) FILETIME=[57610610:01C79668]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied 1-6.
