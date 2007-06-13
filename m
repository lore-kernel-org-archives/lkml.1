Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbXFMOsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbXFMOsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbXFMOsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:48:47 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:6192 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbXFMOsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:48:46 -0400
Date: Wed, 13 Jun 2007 15:48:16 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dmitriy Monakhov <dmonakhov@sw.ru>
cc: linux-kernel@vger.kernel.org, npiggin@suse.de, mark.fasheh@oracle.com,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] new aop loop fix
In-Reply-To: <20070613172939.GE13815@localhost.sw.ru>
Message-ID: <Pine.LNX.4.64.0706131543380.10580@blonde.wat.veritas.com>
References: <20070613134631.GB13815@localhost.sw.ru>
 <Pine.LNX.4.64.0706131426070.4539@blonde.wat.veritas.com>
 <20070613172939.GE13815@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAbGludXgtZXh0NEB2Z2VyLmtlcm5lbC5vcmcAZG1vbmFraG92QHN3LnJ1AG5waWdnaW5Ac3VzZS5kZQBtYXJrLmZhc2hlaEBvcmFjbGUuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Dmitriy Monakhov wrote:
> Btw: Nick's patches broke  LO_CRYPT_XOR mode,

It would help him if you could describe how.

> but it is ok because
> this feature was absolete and not used by anyone, am i right here?

I know nothing of this; but so long as its code remains in the driver,
I'd say we should be supporting it rather than breaking it.

Hugh
