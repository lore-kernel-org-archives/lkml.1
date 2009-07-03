Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZGCXPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZGCXPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 19:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZGCXPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 19:15:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:44714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZGCXPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 19:15:02 -0400
Message-ID: <4A4E90CD.6070905@kernel.org>
Date: Sat, 04 Jul 2009 08:14:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       cl@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org>
In-Reply-To: <1245850216-31653-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 23:14:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> This patchset is combination of the following two patchsets.
> 
> [1] x86,percpu: generalize 4k and lpage allocator
> [2] percpu: teach lpage allocator about NUMA

Alpha changes from linus#master pulled into #for-next and this
patchset has been published in #for-next on top of that.

Thanks.

-- 
tejun
