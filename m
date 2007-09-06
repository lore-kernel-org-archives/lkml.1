Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbXIFFks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbXIFFks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 01:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXIFFkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 01:40:41 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:15702 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXIFFkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 01:40:40 -0400
X-IronPort-AV: E=Sophos;i="4.20,213,1186383600"; 
   d="scan'208";a="174609587"
To: rct@gherkin.frus.com (Bob Tracy)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.23-rc5 panics
X-Message-Flag: Warning: May contain useful information
References: <20070906052434.B7420DBA2@gherkin.frus.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 05 Sep 2007 22:40:39 -0700
In-Reply-To: <20070906052434.B7420DBA2@gherkin.frus.com> (Bob Tracy's message of "Thu, 6 Sep 2007 00:24:34 -0500 (CDT)")
Message-ID: <adar6lctkq0.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Sep 2007 05:40:39.0533 (UTC) FILETIME=[750B39D0:01C7F048]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, I was running 2.6.23-rc5 on my laptop (along with iwlwifi-0.1.14
for wireless) and I saw the same symptom: panic (blinking capslock)
while in X.  I saw one panic out of maybe 12 hours of uptime over a
few reboots.  The same system is quite stable with the stock Ubuntu
2.6.22 kernel.

My laptop is a Thinkpad X60s (core duo) so quite a different system.

I'm traveling at the moment so I probably won't be able to gather much
debugging info until next week.

 - R.
