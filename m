Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYAUVLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYAUVLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYAUVLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:11:24 -0500
Received: from ns2.lanforge.com ([66.165.47.211]:43594 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYAUVLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:11:23 -0500
Message-ID: <47950A71.5010304@candelatech.com>
Date: Mon, 21 Jan 2008 13:11:13 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <4794F848.9020402@nortel.com>
In-Reply-To: <4794F848.9020402@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> Is there anything else we can do to minimize the latency of network 
> packet processing and avoid having to crank the rx ring size up so high?

Why is it such a big deal to crank up the rx queue length?  Seems like
a perfectly normal way to handle bursts like this...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

