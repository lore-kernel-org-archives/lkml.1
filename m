Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZKYC14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZKYC14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 21:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbZKYC1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 21:27:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:37592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758248AbZKYC1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 21:27:54 -0500
Message-ID: <4B0C9382.9010100@kernel.org>
Date: Tue, 24 Nov 2009 18:16:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
Subject: Re: pci related patches 11-21-2009
References: <4B07A658.8080709@kernel.org> <20091124132635.5fbe553c@jbarnes-piketon>
In-Reply-To: <20091124132635.5fbe553c@jbarnes-piketon>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Sat, 21 Nov 2009 00:35:36 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> please check several patches from
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git
>> for-pci
>>
>>
>> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=shortlog;h=refs/heads/for-pci
> 
> The DMAR stuff can just go through the DMAR tree.

sent to David Woodhouse two times.

thinking you could pick up too. it is under drivers/pci ?


> 
> I don't see the two debug output patches on linux-pci, did you post
> them there?

will post them there.

> 
> I commented on one of the resource patches, I'll check the other two
> (long standing leaf release and pciehp) ones again; I mainly want a
> bunch of tested-bys for those.
thanks. thought will get one Reviewed-by and Tested-by from Kenji.
still need to address bridges resource shrink hotplug bridges other than pcie.
already sent him one add-on patch.
> 
> The x86_pci_rootbus one looks ok I think, I'll see about applying that
> today.

Thanks

Yinghai
