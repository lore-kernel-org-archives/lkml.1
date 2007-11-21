Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbXKUWiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbXKUWiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXKUWh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:37:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbXKUWh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:37:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Zachary Amsden <zach@vmware.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: TLS cleanup
In-Reply-To: Zachary Amsden's message of  Wednesday, 21 November 2007 10:34:39 -0800 <1195670079.6352.252.camel@bodhitayantram.eng.vmware.com>
References: <20071121101928.A08CF26F8BE@magilla.localdomain>
	<20071121102511.08B8A26F8BE@magilla.localdomain>
	<1195670079.6352.252.camel@bodhitayantram.eng.vmware.com>
X-Shopping-List: (1) Televised loser clasps
   (2) Clinical hiders
   (3) Prominent thunder commotions
Message-Id: <20071121223717.2B3EE26F8BE@magilla.localdomain>
Date: Wed, 21 Nov 2007 14:37:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I had a bit of trouble verifying correctness here because of much
> brownian motion.  Any possibility of a pure movement / fixup separation
> to make it easier on the eyes?

Yeah, sorry about that.  It was late and the whole TLS thing was a sudden
afterthought while I was in the middle of doing something else, so I didn't
feel like slicing up the patch any more.  And in my tree, GIT didn't even
do so great a job with noticing this rename.  I'll send a replacement.

Thanks,
Roland
