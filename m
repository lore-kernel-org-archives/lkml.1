Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbZGDDQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbZGDDQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 23:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZGDDQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 23:16:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:48233 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbZGDDQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 23:16:07 -0400
Message-ID: <4A4EC9EA.9070005@kernel.org>
Date: Sat, 04 Jul 2009 12:18:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: linux-next submission requirements (Was: [RFC PATCH] linker script:
 unify usage of discard definition)
References: <4A4E9638.20304@kernel.org> <20090704113448.49a722d2.sfr@canb.auug.org.au>
In-Reply-To: <20090704113448.49a722d2.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 03:16:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Stephen Rothwell wrote:
> Hi Tejun,
> 
> [This is not aimed just at you ... this patch just gave me an
> opportunity to point this out again.]
> 
> On Sat, 04 Jul 2009 08:37:28 +0900 Tejun Heo <tj@kernel.org> wrote:
>> This patch is on top of the current percpu#for-next.
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next
>>
>> Thanks.
>>
>> NOT_SIGNED_OFF_YET
> 
> Well, given no SOB and that this is a RFC patch, it should *not* be in a
> branch that is pulled into linux-next.

It's not _in_ the branch.  It's on _top_ of the branch.

Thanks.

-- 
tejun
