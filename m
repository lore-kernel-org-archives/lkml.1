Return-Path: <linux-kernel-owner+w=401wt.eu-S964795AbXBLI4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795AbXBLI4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964798AbXBLI4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:56:35 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:64423 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964795AbXBLI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:56:34 -0500
Date: Mon, 12 Feb 2007 10:56:28 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Beulich <jbeulich@novell.com>, Christoph Hellwig <hch@lst.de>,
       tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [IA64] swiotlb abstraction (e.g. for Xen)
Message-ID: <20070212085628.GA31181@rhun.ibm.com>
References: <200702070759.l177xIti030295@hera.kernel.org> <20070207083254.GA24561@lst.de> <20070211072555.GA22831@lst.de> <45D025BF.76E4.0078.0@novell.com> <1171268065.6308.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171268065.6308.0.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 09:14:25AM +0100, Arjan van de Ven wrote:

> Xen the linux guest
> or
> Xen the hypervisor?
> 
> if it's the later, why on earth would we want to uglyfy linux for it?
> (arguably it holds in the former case as well)

Xen the hypervisor (i.e., dom0).

Cheers,
Muli
