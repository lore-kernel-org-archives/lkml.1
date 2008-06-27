Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbYF0QCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbYF0QCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYF0QCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:02:13 -0400
Received: from gw.goop.org ([64.81.55.164]:47444 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbYF0QCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:02:12 -0400
Message-ID: <48650F02.5080200@goop.org>
Date: Fri, 27 Jun 2008 09:02:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627155656.GA19180@elte.hu>
In-Reply-To: <20080627155656.GA19180@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm testing on multiple systems in parallel, each is running randconfig 
> kernels. One 64-bit system found a build bug, the other one found a boot 
> crash.
>
> This can happen if certain configs build fine (but crash), certain 
> configs dont even build. Each system does a random walk of the config 
> space.
>   

Yes, but the URL for both the crash and the build failure pointed to the 
same config.  Is one of them a mistake?

> I've applied your two fixes and i'm re-testing.
>   

Thanks,
    J
