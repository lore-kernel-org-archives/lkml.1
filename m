Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbZDCRKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbZDCRKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760559AbZDCRKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:10:34 -0400
Received: from sous-sol.org ([216.99.217.87]:36726 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759935AbZDCRKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:10:32 -0400
Date: Fri, 3 Apr 2009 10:09:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Avi Kivity <avi@redhat.com>, Patrick Mullaney <pmullaney@novell.com>,
       anthony@codemonkey.ws, andi@firstfloor.org, herbert@gondor.apana.org.au,
       Peter Morreale <PMorreale@novell.com>, rusty@rustcorp.com.au,
       agraf@suse.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090403170920.GM18394@sequoia.sous-sol.org>
References: <49D469D2020000A100045FA1@lucius.provo.novell.com> <49D473EA020000C700056627@lucius.provo.novell.com> <49D473EA020000C700056627@lucius.provo.novell.com> <49D4CB38.5030205@redhat.com> <49D4DA54.3090401@novell.com> <49D4DE82.5020306@redhat.com> <49D4F97F.6040507@novell.com> <49D5F669.1070502@redhat.com> <49D6240B.4080809@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D6240B.4080809@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> Let me ask you this:  If you had a clean slate and were designing a
> hypervisor and a guest OS from scratch:  What would you make the bus
> look like?

Well, virtio did have a relatively clean slate. And PCI (as _one_
transport option) is what it looks like.  It's not the only transport
(as Avi already mentioned it works for s390, for example).

BTW, from my brief look at vbus, it seems pretty similar to xenbus.

thanks,
-chris
