Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZHSUx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZHSUx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZHSUxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:53:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZHSUxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:53:50 -0400
Date: Wed, 19 Aug 2009 22:53:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090819205330.GA29476@elte.hu>
References: <4A8971A8.2040102@gmail.com> <20090817150844.GA3307@elte.hu> <4A89B08A.4010103@gmail.com> <4A8A674E.8070200@redhat.com> <4A8ABEC9.6090006@gmail.com> <4A8AD678.7050609@redhat.com> <4A8B9B79.9050004@gmail.com> <4A8BA5AE.3030308@redhat.com> <4A8C43D3.7030002@gmail.com> <4A8C627C.70001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8C627C.70001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

>>> IIRC we reuse the PCI IDs for non-PCI.
>>>      
>>
>> You already know how I feel about this gem.
>
> The earth keeps rotating despite the widespread use of 
> PCI IDs.

Btw., PCI IDs are a great way to arbitrate interfaces 
planet-wide, in an OS-neutral, depoliticized and 
well-established way.

It's a bit like CPUID for CPUs, just on a much larger 
scope.

	Ingo
