Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYJHWGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYJHWGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYJHWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:06:38 -0400
Received: from tundra.namei.org ([65.99.196.166]:40205 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbYJHWGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:06:37 -0400
Date: Thu, 9 Oct 2008 09:06:20 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] integrity
In-Reply-To: <1223475584.3103.8.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0810090905570.18606@tundra.namei.org>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com>  <alpine.LRH.1.10.0810081553090.13169@tundra.namei.org> <1223475584.3103.8.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008, Mimi Zohar wrote:

> On Wed, 2008-10-08 at 15:56 +1100, James Morris wrote:
> > On Tue, 7 Oct 2008, Mimi Zohar wrote:
> > 
> > >   The integrity-TPM-internal-kernel-interface.patch prereqs:
> > >         TPM-update-char-dev-BKL-pushdown.patch
> > >         TPM-num_opens-to-is_open-variable-change.patch
> > >         TPM-rcu-locking.patch
> > >         TPM-addition-of-pnp-remove.patch
> > >         TPM-Fixed-tpm_release-timing.patch
> > 
> > Where are these patches?
> > 
> > i.e. are they in a tree?  If so, which one?  If not, they need to be 
> > posted in this series.
> > 
> > 
> > 
> > - James
> 
> The TPM patches have not, as yet, been picked up.
> 
> These TPM patches are base TPM changes, not really related to the
> integrity patches and certainly not dependent them.  However the reverse
> is not true.  The integrity-tpm-internal-kernel-interface patch is
> dependent on, at least, the TPM-rcu-locking patch.

Please repost the TPM patches, then.

-- 
James Morris
<jmorris@namei.org>
