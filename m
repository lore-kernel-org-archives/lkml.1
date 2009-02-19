Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbZBSAby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbZBSAby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZBSAbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:31:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:45683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbZBSAbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:31:45 -0500
Message-ID: <499CA851.6090407@kernel.org>
Date: Thu, 19 Feb 2009 09:31:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <20090218134331.GC1300@elte.hu>
In-Reply-To: <20090218134331.GC1300@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Feb 2009 00:31:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>>   0001-vmalloc-call-flush_cache_vunmap-from-unmap_kernel.patch
>>   0002-module-fix-out-of-range-memory-access.patch
> 
> Hm, these two seem to be .29 material too, agreed?

Yeap.

Thanks.

-- 
tejun
