Return-Path: <linux-kernel-owner+w=401wt.eu-S2992926AbXCIDT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992926AbXCIDT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992923AbXCIDT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:19:56 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:7145 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992921AbXCIDTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:19:55 -0500
X-IronPort-AV: i="4.14,265,1170662400"; 
   d="scan'208"; a="364775645:sNHT48131592"
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: "David Brown" <dmlb2000@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: KVM and rtc missing interupts 2.6.21-rc3
X-Message-Flag: Warning: May contain useful information
References: <9c21eeae0703081348i713c996bked9ebe2af76bc2db@mail.gmail.com>
	<adatzwvxuta.fsf@cisco.com>
	<75b66ecd0703081721y75abccbet32a3c5de906132c8@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 08 Mar 2007 19:19:53 -0800
In-Reply-To: <75b66ecd0703081721y75abccbet32a3c5de906132c8@mail.gmail.com> (Lee Revell's message of "Thu, 8 Mar 2007 20:21:42 -0500")
Message-ID: <ada3b4fxfvq.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2007 03:19:53.0838 (UTC) FILETIME=[CE3FB0E0:01C761F9]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Holding a lock too long should be easy to debug with the -rt patch -
 > set the preemption related options to match mainline, and enable the
 > latency tracer.

Good idea, I'll give it a shot when I get a chance.
