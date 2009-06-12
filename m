Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZFLHUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZFLHUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZFLHUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:20:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36117 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbZFLHUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:20:22 -0400
Message-ID: <4A320197.1070504@redhat.com>
Date: Fri, 12 Jun 2009 10:19:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the kvm tree
References: <20090612125745.afadf2aa.sfr@canb.auug.org.au>
In-Reply-To: <20090612125745.afadf2aa.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2009 05:57 AM, Stephen Rothwell wrote:
> Hi Avi,
>
> Today's linux-next merge of the kvm tree got conflicts in about 23
> files.  This has happened because only a subset of the kvm tree that is
> merged into the linux-next tree has been merged into Linus' tree *and*
> that subset was rebased before the merge happened.
>
> I have dropped the kvm tree.
>    

I'll merge asap.

> Is there some other branch that I should be including in linux-next
> instead of the current one i.e. something that represents what you will
> actually send to Linus that doesn't need to be rebased before that
> happens?
>    

There's always kvm-updates/2.6.n+1, but that doesn't get updates until 
the merge window gets close.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

