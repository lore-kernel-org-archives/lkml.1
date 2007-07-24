Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbXGXVMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbXGXVMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXGXVMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:12:24 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:50195 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXGXVMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:12:23 -0400
Message-ID: <46A66B26.5040201@nortel.com>
Date: Tue, 24 Jul 2007 15:12:06 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Tong Li <tong.n.li@intel.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com> <46A66393.5000705@redhat.com>
In-Reply-To: <46A66393.5000705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2007 21:12:13.0897 (UTC) FILETIME=[4E815390:01C7CE37]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

>> We have another SMP box that would benefit from group scheduling, but 
>> we can't use it because the load balancer is not nearly good enough.

> Which scheduler?  Have you tried the CFS group scheduler patches?

CKRM as well.

Haven't tried the CFS group scheduler, as we're stuck on a way old 
kernel and I've been too busy to play with the new stuff.

Chris
