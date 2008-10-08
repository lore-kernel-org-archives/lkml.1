Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYJHOU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYJHOU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 10:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbYJHOUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 10:20:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49870 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYJHOUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 10:20:16 -0400
Subject: Re: [PATCH 0/4] integrity
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
In-Reply-To: <alpine.LRH.1.10.0810081553090.13169@tundra.namei.org>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.1.10.0810081553090.13169@tundra.namei.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 10:19:44 -0400
Message-Id: <1223475584.3103.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 15:56 +1100, James Morris wrote:
> On Tue, 7 Oct 2008, Mimi Zohar wrote:
> 
> >   The integrity-TPM-internal-kernel-interface.patch prereqs:
> >         TPM-update-char-dev-BKL-pushdown.patch
> >         TPM-num_opens-to-is_open-variable-change.patch
> >         TPM-rcu-locking.patch
> >         TPM-addition-of-pnp-remove.patch
> >         TPM-Fixed-tpm_release-timing.patch
> 
> Where are these patches?
> 
> i.e. are they in a tree?  If so, which one?  If not, they need to be 
> posted in this series.
> 
> 
> 
> - James

The TPM patches have not, as yet, been picked up.

These TPM patches are base TPM changes, not really related to the
integrity patches and certainly not dependent them.  However the reverse
is not true.  The integrity-tpm-internal-kernel-interface patch is
dependent on, at least, the TPM-rcu-locking patch.

Mimi

