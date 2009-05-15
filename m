Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbZEOJg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbZEOJg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761164AbZEOJgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:36:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761963AbZEOJgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:36:43 -0400
Message-ID: <4A0D37A5.2070001@novell.com>
Date: Fri, 15 May 2009 18:36:37 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       linux-kernel-owner@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH 2.6.30-rc5] x86,percpu: fix pageattr handling with
 remap allocator, take#2
References: <1242361739-21186-1-git-send-email-tj@kernel.org>
In-Reply-To: <1242361739-21186-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
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
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-pageattr

Patches 0002 and 0003 updated per Jan's comments.  New git commit ID
is 229f8495873f9f8928c9c99f790f2e0f4b6b0804.

Thanks.

-- 
tejun
