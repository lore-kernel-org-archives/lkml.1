Return-Path: <linux-kernel-owner+w=401wt.eu-S1751550AbZHSCQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbZHSCQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 22:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZHSCQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 22:16:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44243
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbZHSCQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 22:16:47 -0400
Date: Tue, 18 Aug 2009 19:16:58 -0700 (PDT)
Message-Id: <20090818.191658.138119023.davem@davemloft.net>
To: tj@kernel.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       amwang@redhat.com
Subject: Re: [GIT PULL] percpu fixes for 2.6.31-rc6
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A8B57AF.9000000@kernel.org>
References: <4A84ED76.2050107@kernel.org>
	<4A8B57AF.9000000@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Wed, 19 Aug 2009 10:38:55 +0900

> Tejun Heo wrote:
>> Please consider pulling from the following percpu fixes tree.
>> 
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus
> 
> Any news about this?  This affects booting on some sparc64 machines.
> If the change is too pervasive at this stage, we can consider
> reverting dynamic percpu allocator conversion for sparc64.

I'm all for these changes, especially since they fix those
sparc64 systems :-)
