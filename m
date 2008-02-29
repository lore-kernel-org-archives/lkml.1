Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbYB2VUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbYB2VUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYB2VUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:20:32 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17511 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbYB2VUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:20:31 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5242"; a="1039837"
Message-ID: <47C8771C.1070001@qualcomm.com>
Date: Fri, 29 Feb 2008 13:20:28 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
References: <20080227222103.673194000@chello.nl>	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
In-Reply-To: <1204318980.6243.133.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> But yeah, this was just a quick hack to show the idea, glad you like it.
> Will try to flesh it out a bit in the coming week.

Are you going to add code for "boot" cpuset ?
I wrote user-space code that is does that, but as I understand from previous 
discussions we want to create that in the kernel.

Max

