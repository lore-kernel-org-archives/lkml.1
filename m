Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbZENQVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbZENQVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761486AbZENQUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:20:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:47062 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761058AbZENQUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:20:44 -0400
Message-ID: <4A0C4528.90608@novell.com>
Date: Fri, 15 May 2009 01:22:00 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       linux-kernel-owner@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
In-Reply-To: <1242305390-21958-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Upon ack, please pull from the following git tree.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-pageattr

git tree updated to contain two updated patches.  The new commit ID is
42fec16c045bc5259002faacdcd23e4530b6482e.

Thanks.

-- 
tejun
