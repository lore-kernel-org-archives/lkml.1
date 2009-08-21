Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZHUNfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZHUNfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932161AbZHUNfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:35:32 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56224 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755050AbZHUNfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:35:32 -0400
Message-ID: <4A8EA29D.2070407@sgi.com>
Date: Fri, 21 Aug 2009 15:35:25 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest Linus tree oopses on Nehalem box
References: <4A8E7CBE.3020209@sgi.com> <20090821114645.GD24647@elte.hu> <4A8E9B63.4090400@sgi.com> <20090821132658.GD10263@elte.hu>
In-Reply-To: <20090821132658.GD10263@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 03:26 PM, Ingo Molnar wrote:
> I'd say it's timing related and still unfixed - crashes that deep in
> the scheduler we'd sure know about, had we fixed such in any recent
> kernels. Do you still have the last 10 lines of the bootup leading
> up to the crash?

Hi Ingo,

Sorry no I don't have that part anymore :-( Should have saved it.

Cheers,
Jes

