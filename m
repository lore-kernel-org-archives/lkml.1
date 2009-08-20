Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZHTMNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZHTMNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZHTMNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:13:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbZHTMNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:13:48 -0400
Date: Thu, 20 Aug 2009 15:12:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090820121205.GC5448@redhat.com>
References: <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws> <4A8AA9BD.2070909@gmail.com> <4A8AB076.6080906@redhat.com> <4A8ACE1F.6020402@gmail.com> <20090818165139.GC19846@redhat.com> <4A8B8F4E.80207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8B8F4E.80207@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 01:36:14AM -0400, Gregory Haskins wrote:
> >> So where is the problem here?
> > 
> > If virtio net in guest could be improved instead, everyone would
> > benefit.
> 
> So if I whip up a virtio-net backend for vbus with a PCI compliant
> connector, you are happy?

I'm currently worried about venet versus virtio-net guest situation, if
you drop it and switch to virtio net instead that issue's resolved.

I don't have an opinion on vbus versus pci, and I only speak for myself.

-- 
MST
