Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbZAOK26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbZAOK26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbZAOK2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:28:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:34235 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763658AbZAOK2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:28:32 -0500
Message-ID: <496F0F96.4010800@kernel.org>
Date: Thu, 15 Jan 2009 19:27:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <200901151253.44016.rusty@rustcorp.com.au>
In-Reply-To: <200901151253.44016.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 10:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> percpu_read()
> 
> I already have this in my patch series.
> 
> Frankly, it starts to get marginal in generic code after percpu_read(),
> so I didn't do them (and the per-cpu interfaces are already pretty wide).
> 
> Tejun, is now a good time to rebase my alloc_percpu series on top of
> yours? I'm more than happy to hand them over to someone with more cycles...

Sure, send them my way.

Thanks.

-- 
tejun
