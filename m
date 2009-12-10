Return-Path: <linux-kernel-owner+w=401wt.eu-S1761655AbZLJTp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761655AbZLJTp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761350AbZLJTpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:45:24 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:1882 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761644AbZLJTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:45:20 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIreIEurRN+K/2dsb2JhbADBDpcXhCsE
X-IronPort-AV: E=Sophos;i="4.47,376,1257120000"; 
   d="scan'208";a="117636184"
From: Roland Dreier <rdreier@cisco.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	<alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	<1260459601.18520.26.camel@skunk>
	<alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	<6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	<alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	<21d7e9970912101137k6f789e86x279aaf037732acb5@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Dec 2009 11:45:26 -0800
In-Reply-To: <21d7e9970912101137k6f789e86x279aaf037732acb5@mail.gmail.com>
	(Dave Airlie's message of "Fri, 11 Dec 2009 05:37:21 +1000")
Message-ID: <adavdgelijt.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Dec 2009 19:45:26.0390 (UTC) FILETIME=[51F95160:01CA79D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > If someone has time to take the nouveau patches and convert all the dubious
 > pieces of code to firmware loader interface and set it up so the main code
 > can be merged upstream and the firmware left to one side and someone
 > else can possibly redistribute the firmware then it might happen quicker.

I don't have any nvidia hardware.  Someone send me an ion netbook and
I'll take care of converting nouveau to firmware loader  :)

 - R.
