Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0CJRdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:33:40 -0500
Received: from reaktio.net ([194.89.68.22]:41261 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab0CJRdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:33:38 -0500
Date: Wed, 10 Mar 2010 19:33:39 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 0 of 5] PV on HVM Xen
Message-ID: <20100310173339.GO1878@reaktio.net>
References: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 03:46:54PM +0000, Stefano Stabellini wrote:
> Hi all,
> this is a reduced and rebased version of the patch series I sent
> yesterday "enhanced PV on HVM": this series is based on Linux 2.5.32 and
> can be applied now, it includes everything but the pirq remapping
> related functions that are not ready to be upstreamed at the moment.
> 
> Therefore it just achieves the goal of enabling PV devices in Linux
> running in a Xen HVM domain, it doesn't allow event channels delivery in
> place of interrupts.
> 
> The patch series consists of 5 patches, each patch comes with a detailed
> description.
> In order for this to work we also need a patch for Xen, that is being
> worked on as we speak.
>

Hmm.. is it possible to get PV-on-HVM drivers working on older Xen versions,
that don't have additional patches? 

Just like the unmodified_drivers works for 2.6.18 and 2.6.27.

-- Pasi

