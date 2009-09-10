Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZIJJXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZIJJXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZIJJXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:23:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:40183 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbZIJJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:23:07 -0400
Date: Thu, 10 Sep 2009 19:21:33 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       Jan Beulich <jbeulich@novell.com>, adi@vmware.com, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] TPM: Fixup boot probe timeout for tpm_tis driver
In-Reply-To: <1252545267.4837.62.camel@blackbox>
Message-ID: <alpine.LRH.2.00.0909101919400.3312@tundra.namei.org>
References: <20090909232218.GK406@obsidianresearch.com> <1252545267.4837.62.camel@blackbox>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Rajiv Andrade wrote:

> Andy Isaacson sent this a while ago in a patchset, I think I lost track
> of it in the middle of the other patches, sorry. In any case, ACK.
> 
> http://marc.info/?l=linux-kernel&m=124650185023490&w=2


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

This will be pushed to Linus within the next day as part of the merge for 
2.6.32, and I'm guessing needs to be in -stable.

-- 
James Morris
<jmorris@namei.org>
