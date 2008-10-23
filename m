Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYJWHTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYJWHTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYJWHTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:19:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:19019 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbYJWHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=eaKIF1AMS/kZDm5f161kdFp1NOxaswCu2rht4fbwVkMQTv3zr1wea9iP00rsE90hhw
         NCTCOccr1ZIjyjTJnfzgb8K9SOd8iTTsorYjBOpEuYISgz44LPLe5D/8YXWgElTT2RQH
         wLeLuFhLAzbuTuGwiFuizbdZBVduIYO2AEqzI=
Message-ID: <7c86c4470810230019g65bce230yfc0c86cc55056e34@mail.gmail.com>
Date: Thu, 23 Oct 2008 09:19:06 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 00/24] perfmon3: introduction
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20081022102257.60dc8d08.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
	 <20081021.212502.41487120.davem@davemloft.net>
	 <7c86c4470810220139h49269138g844194bd5db3d5c2@mail.gmail.com>
	 <200810220958.23266.jbarnes@virtuousgeek.org>
	 <20081022102257.60dc8d08.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Wed, Oct 22, 2008 at 7:22 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 22 Oct 2008 09:58:22 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> It is several years late.  For me the problem has been that we do a lot
> of review and have lots of discussion but then the trail goes cold for
> six months and when it all pops up again the code has changed and/or
> we've all forgotten about it again.
>

The kind of changes I have made following ealier reviews are not trivial,
It takes time and I do other things as well. So I could not really post on
LKML every week with something that would work and be worthy of
your time.

> What it needs is a sustained effort to get it over the hump.  How's
> about getting it into linux-next asap and then we all agree to do the
> re-re-re-review and runtime testing for a 2.6.29 merge?
>
Let's do this, then.

Thanks.
