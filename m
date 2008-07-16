Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYGPInZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYGPInZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYGPInR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:43:17 -0400
Received: from ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk ([217.169.26.28]:53452
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYGPInQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:43:16 -0400
Date: Wed, 16 Jul 2008 09:43:10 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 part 2] [MIPS] make the pcibios_max_latency
	variable static
Message-ID: <20080716084310.GA22957@linux-mips.org>
References: <1216141052-28005-2-git-send-email-dmitri.vorobiev@movial.fi> <1216195309-13069-1-git-send-email-dmitri.vorobiev@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216195309-13069-1-git-send-email-dmitri.vorobiev@movial.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 11:01:49AM +0300, Dmitri Vorobiev wrote:

> Along with making the pcibios_max_latency variable static,
> its declaration needs to be removed from the header file.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
> ---
> 
> Hi Ralf,
> 
> Forgot about this one yesterday, sorry.

No big deal, lmo's internet connection was down for part of the afternoon
so I wasn't doing as much patch stuff as I was hoping to ...

I folded part 2 into part 1 of your patch and applied the result.

Thanks,

  Ralf
