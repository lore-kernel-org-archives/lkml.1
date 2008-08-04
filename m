Return-Path: <linux-kernel-owner+w=401wt.eu-S1752422AbYHDRzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbYHDRzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYHDRzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:55:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24733 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYHDRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:55:09 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5352"; a="5129930"
Message-ID: <48974294.70108@qualcomm.com>
Date: Mon, 04 Aug 2008 10:55:32 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Remove EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU
References: <20080730195831.GA31838@sgi.com>
In-Reply-To: <20080730195831.GA31838@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dimitri Sivanich wrote:
> This removes the EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU on the x86 architecture.
Looks good to me.

> One question, should we default to 'Y'?
That I'm not sure. I'd personally be ok if the default was 'Y'.

Max
