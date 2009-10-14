Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZJNRpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZJNRpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZJNRpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:45:42 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:24396 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbZJNRpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:45:42 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAL+q1UqrRN+J/2dsb2JhbADCUJhdhC4E
X-IronPort-AV: E=Sophos;i="4.44,559,1249257600"; 
   d="scan'208";a="196689356"
From: Roland Dreier <rdreier@cisco.com>
To: Greg KH <gregkh@suse.de>
Cc: torvalds@linux-foundation.org, Bill Pemberton <wfp5p@virginia.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Staging: Comedi: Add missing <linux/sched.h> includes
References: <adazl7taok3.fsf@cisco.com> <20091014171603.GA28296@suse.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 Oct 2009 10:45:04 -0700
In-Reply-To: <20091014171603.GA28296@suse.de> (Greg KH's message of "Wed, 14
	Oct 2009 10:16:03 -0700")
Message-ID: <adak4yxamzj.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Oct 2009 17:45:05.0115 (UTC) FILETIME=[103672B0:01CA4CF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Already in my tree :(

Any plans to get it upstream?  As far as I can tell, these drivers
haven't built since before -rc4, so 4 or 5 days at least.

 - R.
