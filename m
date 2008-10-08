Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYJHE7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYJHE7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 00:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYJHE7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 00:59:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:40247 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbYJHE7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 00:59:33 -0400
Date: Wed, 8 Oct 2008 15:56:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] integrity
In-Reply-To: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0810081553090.13169@tundra.namei.org>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Mimi Zohar wrote:

>   The integrity-TPM-internal-kernel-interface.patch prereqs:
>         TPM-update-char-dev-BKL-pushdown.patch
>         TPM-num_opens-to-is_open-variable-change.patch
>         TPM-rcu-locking.patch
>         TPM-addition-of-pnp-remove.patch
>         TPM-Fixed-tpm_release-timing.patch

Where are these patches?

i.e. are they in a tree?  If so, which one?  If not, they need to be 
posted in this series.



- James
-- 
James Morris
<jmorris@namei.org>
