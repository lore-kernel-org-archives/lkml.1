Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXLDV0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXLDV0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXLDV0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:26:40 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:33836 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbXLDV0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:26:38 -0500
X-Greylist: delayed 1793 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 16:26:38 EST
Date: Tue, 4 Dec 2007 21:55:14 +0100 (CET)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: Ingo Molnar <mingo@elte.hu>
cc: Len Brown <lenb@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
In-Reply-To: <20071204122649.GB27286@elte.hu>
Message-ID: <alpine.DEB.0.99999.0712042152070.9287@sheep.housecafe.de>
References: <200711280121.18376.lenb@kernel.org> <20071204122649.GB27286@elte.hu>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Ingo Molnar wrote:
> thanks for the patch and the extensive description. I've applied this to
> x86.git. Do you agree that this has no urgency for v2.6.24 and is thus
> v2.6.25 material?

Pardon my ignorance, but: aren't we in -rc already? I was under the 
assumption that during the -rc phase only (release-)critical bugfixes 
would be applied? So this one *must* be 2.6.25 material, right?

Thanks,
Christian.
-- 
BOFH excuse #54:

Evil dogs hypnotised the night shift
