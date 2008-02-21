Return-Path: <linux-kernel-owner+w=401wt.eu-S1765335AbYBUDuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765335AbYBUDuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 22:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYBUDuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 22:50:13 -0500
Received: from ozlabs.org ([203.10.76.45]:55166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbYBUDuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 22:50:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18364.57114.563431.730805@cargo.ozlabs.ibm.com>
Date: Thu, 21 Feb 2008 13:16:58 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: galak@kernel.crashing.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2][POWERPC] Fix initial lmb add region with a non-zero
	base
In-Reply-To: <20080219.193125.04536962.davem@davemloft.net>
References: <Pine.LNX.4.64.0802191350590.10089@blarg.am.freescale.net>
	<20080219.163003.152862383.davem@davemloft.net>
	<4130F47E-4F4A-4911-B63B-403A8C423565@kernel.crashing.org>
	<20080219.193125.04536962.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> I'm ambivalent but I would obviously prefer 2.6.25 because
> it would allow me to proceed more easily with my sparc64
> NUMA work as well as get your bug fixes in more smoothly.

Sounds like we should get Stephen to put it in linux-next-stable once
we're convinced it's all OK.

Paul.
