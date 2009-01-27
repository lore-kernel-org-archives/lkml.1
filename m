Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZA0XIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZA0XIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZA0XHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:07:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:39671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZA0XHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:07:43 -0500
Message-ID: <497F93A2.404@kernel.org>
Date: Wed, 28 Jan 2009 08:07:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
References: <20090115183942.GA6325@elte.hu> <200901201328.24605.rusty@rustcorp.com.au> <49756E6E.2060409@kernel.org> <200901271213.18605.rusty@rustcorp.com.au> <497E705B.5000302@kernel.org> <20090127131317.GF23121@elte.hu>
In-Reply-To: <20090127131317.GF23121@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 27 Jan 2009 23:07:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>>> Tejun, any chance of you updating the tj-percpu tree? My current 
>>> patches are against Linus's tree, and rebasing them on yours involves 
>>> some icky merging.
>> If Ingo is okay with it, I'm fine with it too.  Unless Ingo objects, 
>> I'll do it tomorrow-ish (still big holiday here).
> 
> Sure - but please do it as a clean rebase ontop of latest, not as a 
> conflict-merge, as i'd expect there to be quite many clashes.

Alrighty, re-basing.

Thanks.

-- 
tejun
