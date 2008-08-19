Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYHSATX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYHSATX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYHSATO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:19:14 -0400
Received: from styx.suse.cz ([82.119.242.94]:46547 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754037AbYHSATN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:19:13 -0400
Date: Tue, 19 Aug 2008 02:19:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       Leo Duran <leo.duran@amd.com>
Subject: Re: [PATCH] x86 iommu: remove unneeded parenthesis
In-Reply-To: <20080819001728.GD9914@elte.hu>
Message-ID: <alpine.LNX.1.10.0808190218360.18058@jikos.suse.cz>
References: <alpine.LNX.1.10.0808190211060.18058@jikos.suse.cz> <20080819001728.GD9914@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Ingo Molnar wrote:

>> The parenthesis in __iommu_queue_command() are not needed when assigning
>> into 'target' variable.
>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> applied to tip/x86/urgent - thanks Jiri.

Thanks.

> [ Btw., the patch was whitespace damaged (leading double spaces, etc.),
>  i fixed it up by hand. Please check Documentation/email-clients.txt. ]

Hmm, this is the first time ever my [al]pine to damage patch. I will 
investigate this, thanks for letting me know.

-- 
Jiri Kosina
SUSE Labs
