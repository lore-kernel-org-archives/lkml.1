Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYKDTh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYKDTh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYKDThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:37:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44143 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbYKDThU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:37:20 -0500
Message-ID: <4910A43B.5030908@redhat.com>
Date: Tue, 04 Nov 2008 14:36:27 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] change CONFIG_NUMA description
References: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> CONFIG_NUMA description talk about a bit old thing.
> So, following changes are better.
> 
> o CONFIG_NUMA is no longer EXPERIMENTAL
> o Opteron is not the only processor of NUMA topology on x86_64 no longer, but also Intel Core7i has it.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

a) It's Core i7, not Core 7i
b) Core i7 is, at least so far, the single-socket version, so NUMA 
doesn't apply.

I think we should let Intel write the CONFIG_NUMA description for 
Nehalem processors.

-- Chris
