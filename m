Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYGUQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYGUQeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYGUQeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:34:06 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:16140 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYGUQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:34:05 -0400
X-IronPort-AV: E=Sophos;i="4.31,224,1215388800"; 
   d="scan'208";a="67455519"
From: Roland Dreier <rdreier@cisco.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
Subject: Re: [PATCH 2/2] IB/ehca: Default value for Local CA ACK Delay
References: <200807211313.23648.fenkes@de.ibm.com>
	<200807211316.37224.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 21 Jul 2008 09:34:02 -0700
In-Reply-To: <200807211316.37224.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Mon, 21 Jul 2008 13:16:36 +0200")
Message-ID: <adaod4r5h8l.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jul 2008 16:34:03.0186 (UTC) FILETIME=[96043120:01C8EB4F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied 1 and 2
