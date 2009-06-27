Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZF0D0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZF0D0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 23:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZF0D0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 23:26:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:35316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbZF0D0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 23:26:42 -0400
Message-ID: <4A459142.60301@kernel.org>
Date: Sat, 27 Jun 2009 12:25:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET core/percpu] percpu: convert most archs to dynamic
 percpu, take#4
References: <1245825924-30412-1-git-send-email-tj@kernel.org> <4A459075.4010709@kernel.org>
In-Reply-To: <4A459075.4010709@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 27 Jun 2009 03:25:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Tejun Heo wrote:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git convert-most-archs
> 
> Rebased tree w/ the build breakage James spotted fixed pulled into
> #for-next.  It won't be rebased from now on unless something drastic
> happens.

Eh... after hitting send I realized alpha was still broken.  It'll go
through another revision.

Thanks.

-- 
tejun
