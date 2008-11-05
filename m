Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYKEVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYKEVMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYKEVMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:12:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:62452 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYKEVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:12:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=scuBDsh6EXTiWZJDqpSIR+b/4WjAdTbUIUihqzO8dk5y5Aei1+fYza4FEJOujJG5aa
         O//mGBnm7ylVN04+MHNyiLQFo55NWE+LsgDPhi2+SWzofTIKlHRR82ILZ0aPIOe2540k
         1j8vuubhFuKfV3vSSRIZ7qNi31HHS3T2qhH+A=
Message-ID: <19f34abd0811051312o1fe733d8g4d0075aa7eefa964@mail.gmail.com>
Date: Wed, 5 Nov 2008 22:12:04 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Git next: Second stage of cpu_alloc patches
Cc: "Christoph Lameter" <cl@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com
In-Reply-To: <20081105082754.2d41f0d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
	 <20081104195205.fe1bf62b.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0811050753120.11867@quilx.com>
	 <20081105082754.2d41f0d1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 5:27 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> We need to get alpha sorted out too.  Frankly, if we can't get anyone to
> review/test/ack the alpha genirq conversion then I'd say merge it
> anyway.  I'll make sure that it at least compiles.

Sounds like a bad strategy. What are these patches you're talking
about, and where can I find them?

I mean, isn't "merge anyway" the same as admitting defeat? I thought
we were going for 100% "review coverage".


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
