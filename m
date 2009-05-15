Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbZEOKIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbZEOKIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbZEOKIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:08:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbZEOKIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:08:43 -0400
Message-ID: <4A0D3F26.9050409@novell.com>
Date: Fri, 15 May 2009 19:08:38 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH 2.6.30-rc5] x86,percpu: fix pageattr handling	withremap
 allocator, take#2
References: <1242361739-21186-1-git-send-email-tj@kernel.org>	<4A0D37A5.2070001@novell.com> <4A0D57920200007800001150@novell.com>
In-Reply-To: <4A0D57920200007800001150@novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Tejun Heo <teheo@novell.com> 15.05.09 11:36 >>>
>> Tejun Heo wrote:
>>> Hello,
>>>
>>> Upon ack, please pull from the following git tree.
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-pageattr
>> Patches 0002 and 0003 updated per Jan's comments.  New git commit ID
>> is 229f8495873f9f8928c9c99f790f2e0f4b6b0804.
> 
> With this the whole series is
> 
> Reviewed-by: Jan Beulich <jbeulich@novell.com>

Thanks.  Much appreciated.

-- 
tejun
