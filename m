Return-Path: <linux-kernel-owner+w=401wt.eu-S935847AbZLPWow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935847AbZLPWow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934286AbZLPWot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:44:49 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38587 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935343AbZLPWos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:44:48 -0500
Date: Wed, 16 Dec 2009 15:44:45 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 0/9] pci: update pci bridge resource to get more big
	range for devices under it - v13
Message-ID: <20091216224445.GA24763@ldl.fc.hp.com>
References: <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit!su.com> <4B0C69AD.3030106@kernel.org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D286.4020607@kernel.org> <20091216125458.42bf222e@jbarnes-piketon> <20091216211158.GF26757@ldl.fc.hp.com> <4B295ED1.3010607@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B295ED1.3010607@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> Alex Chiang wrote:
> > * Jesse Barnes <jbarnes@virtuousgeek.org>:
> >>
> >> Patches 7-9 seem like they've recieved some review from Alex
> >> and Kenji-san, but I don't see acks or reviewed-bys on them.
> >>
> >> Alex and Kenji-san, are you ok with them assuming the
> >> previous patches or something like them go upstream?
> > 
> > Can you please repost your next revision (after taking
> > Jesse's review comments) in a new thread?
> > 
> 
> can you check
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git
> >> master
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-2.6-yinghai.git;a=shortlog;h=refs/heads/master
> 
> i rebased them to linus tree 12-12-2009.

Well, yes, I can read those, but now I have to try and guess 
which patches are 7-9 that Jesse asked me to review.

One reason that it's hard to review your patches is because there 
are many revisions, buried deep within threads. It's not easy for 
reviewers to a) keep track of all them or b) keep track of how 
they inter-relate.

I might be following one subthread, see N revisions for patch x/y 
as replies in there, keep track of the changes mentally, and then 
keep all that state in my mind as I navigate around in the thread 
to try and review patch x+1/y.

Then, trying to figure out how x, x+1, x+2 are all related into 
one coherent change is difficult.

In the future, for PCI patch series, when you have to make 
revisions, please repost as a new thread every time. This will 
make life much easier for reviewers.

Thanks,
/ac

