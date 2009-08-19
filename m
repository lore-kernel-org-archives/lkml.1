Return-Path: <linux-kernel-owner+w=401wt.eu-S1751371AbZHSBjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbZHSBjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZHSBjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:39:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:51697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZHSBjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:39:15 -0400
Message-ID: <4A8B57AF.9000000@kernel.org>
Date: Wed, 19 Aug 2009 10:38:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Amerigo Wang <amwang@redhat.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.31-rc6
References: <4A84ED76.2050107@kernel.org>
In-Reply-To: <4A84ED76.2050107@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 01:38:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tejun Heo wrote:
> Please consider pulling from the following percpu fixes tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

Any news about this?  This affects booting on some sparc64 machines.
If the change is too pervasive at this stage, we can consider
reverting dynamic percpu allocator conversion for sparc64.

Thanks.

-- 
tejun
