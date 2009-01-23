Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbZAWONA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbZAWONA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZAWOMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:12:51 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:26955 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756246AbZAWOMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:12:51 -0500
X-BigFish: VPS-35(zz1432R62a3L98dR936eQ1805Mzzzzz32i6bh43j)
X-WSS-ID: 0KDXGSP-03-DNN-01
Date: Fri, 23 Jan 2009 15:12:26 +0100
From: Robert Richter <robert.richter@amd.com>
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] cpumask: modifiy oprofile initialization
Message-ID: <20090123141221.GB26752@erda.amd.com>
References: <20090122131153.GP21604@erda.amd.com> <1232630055-32451-1-git-send-email-robert.richter@amd.com> <4978A553.8000103@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4978A553.8000103@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 23 Jan 2009 14:12:25.0948 (UTC) FILETIME=[9E1A11C0:01C97D64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.01.09 08:56:51, Mike Travis wrote:
> Robert Richter wrote:
> > Delta patch to f7df8ed164996cd2c6aca9674388be6ef78d8b37 for
> > tip/cpus4096.
> > 
> > Moved initialization to sync_start()/sync_stop(). No changes needed in
> > buffer_sync.h and oprof.c anymore.
> 
> Great, thanks Robert!
> 
> Are you pushing this via some upstream queue so I can drop it from mine?

Mike, it is in the tip tree commit id 4c50d9e (tip/cpus4096).

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

