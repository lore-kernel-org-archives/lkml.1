Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZJPQlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZJPQlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZJPQlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:41:52 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50606 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbZJPQlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:41:52 -0400
Subject: Re: Leaks in trace reported by kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
	 <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
	 <c4e36d110910160807i2298dacp7d37289ca3ad25f@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 16 Oct 2009 17:41:25 +0100
Message-Id: <1255711285.3008.59.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 16:41:26.0686 (UTC) FILETIME=[8113EBE0:01CA4E7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 17:07 +0200, Zdenek Kabelac wrote:
> So I've tested this modified version and it gives much better result
> with respect to amount of leaked objects

BTW, I created this tree with kmemleak patches to be pushed upstream:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/kmemleak.git

It would be easier to test.

-- 
Catalin

