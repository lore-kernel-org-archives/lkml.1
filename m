Return-Path: <linux-kernel-owner+w=401wt.eu-S935332AbZLPVMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935332AbZLPVMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZLPVME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:12:04 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:36960 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbZLPVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:12:01 -0500
Date: Wed, 16 Dec 2009 14:11:58 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 0/9] pci: update pci bridge resource to get more big
	range for devices under it - v13
Message-ID: <20091216211158.GF26757@ldl.fc.hp.com>
References: <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit!su.com> <4B0C69AD.3030106@kernel.org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D286.4020607@kernel.org> <20091216125458.42bf222e@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216125458.42bf222e@jbarnes-piketon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> > 
> > -v13: change resource_list to resource_list_x, to save size and flags
> > aside, otherwise grandchild res will get confused with son's res as
> > could be used

One difficulty that I have in reviewing is the multiple patch
revisions buried deep within a thread.

Blame my small brain for not being able to keep track of all
the revision-as-mail-responses in one coherent body of work.

> Patches 4-6 make me the most nervous, since they have the potential of
> really changing our resource allocation (hopefully for the better) on
> many platforms.
> 
> Linus, can you check them out and see if you're ok with the direction?
> 
> Patches 7-9 seem like they've recieved some review from Alex and
> Kenji-san, but I don't see acks or reviewed-bys on them.
> 
> Alex and Kenji-san, are you ok with them assuming the previous patches
> or something like them go upstream?

Can you please repost your next revision (after taking Jesse's
review comments) in a new thread?

Thank you.
/ac

