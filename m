Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbYC3Aqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbYC3Aqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 20:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYC3Aqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 20:46:33 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:60127 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYC3Aqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 20:46:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au6FAGt/7kdT48OPPGdsb2JhbACBWoZVKYhgAQEBATCWag
Message-ID: <47EEE2E0.4070009@coderworld.net>
Date: Sun, 30 Mar 2008 01:46:24 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Keyboard weirdness: keys get stuck
References: <47EEA097.5000701@coderworld.net> <47EEC51C.2060806@coderworld.net> <20080329234358.GA28667@linux.vnet.ibm.com> <47EED858.7010605@coderworld.net>
In-Reply-To: <47EED858.7010605@coderworld.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Jonsson skrev:
> Dhaval Giani skrev:
>> Can you check if you have CONFIG_GROUP_SCHED enabled? If so, can you
>> disable and test?
>>
> 
> Yes it's enabled, will try without groupsched.

Same behavior without group_sched

regards, Richard
