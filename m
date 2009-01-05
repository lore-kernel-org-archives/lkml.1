Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZAETcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZAETcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZAETcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:32:00 -0500
Received: from relay3.sgi.com ([192.48.171.31]:55738 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753228AbZAETcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:32:00 -0500
Message-ID: <4962602D.4070502@sgi.com>
Date: Mon, 05 Jan 2009 11:31:57 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] cpumask: update pci_bus_show_cpuaffinity to use
 new cpumask API
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <20090104131800.317064000@polaris-admin.engr.sgi.com> <200901051127.03598.jbarnes@virtuousgeek.org>
In-Reply-To: <200901051127.03598.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Sunday, January 4, 2009 5:18 am Mike Travis wrote:
>> Impact: cleanup, reduce stack usage, use new cpumask API.
>>
>> Replace the local cpumask_t variable with a pointer to the
>> const cpumask that needs to be printed.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Can you resend these two against my linux-next branch?
> 
> Thanks,

Sure thing.  Would this be the latest .../sfr/linux-next.git master
tree or would I need to select some other branch?

Thanks,
Mike

