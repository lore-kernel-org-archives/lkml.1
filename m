Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbXKVJK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbXKVJK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 04:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXKVJKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 04:10:44 -0500
Received: from www.tglx.de ([62.245.132.106]:49756 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbXKVJKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 04:10:43 -0500
Date: Thu, 22 Nov 2007 10:10:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [replacement PATCH 6/6] x86: TLS cleanup
In-Reply-To: <20071121223951.2A6F526F8BE@magilla.localdomain>
Message-ID: <alpine.LFD.0.9999.0711221009160.25057@localhost.localdomain>
References: <20071121101928.A08CF26F8BE@magilla.localdomain> <20071121102511.08B8A26F8BE@magilla.localdomain> <1195670079.6352.252.camel@bodhitayantram.eng.vmware.com> <20071121223951.2A6F526F8BE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Roland McGrath wrote:

> 
> This consolidates the four different places that implemented the same
> encoding magic for the GDT-slot 32-bit TLS support.  The old tls32.c was
> renamed and is now only slightly modified to be the shared implementation.

Applied, thanks

	 tglx

