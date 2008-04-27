Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYD0Vbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYD0Vbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 17:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYD0Vbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 17:31:32 -0400
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:46011 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751118AbYD0Vbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 17:31:31 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH][Resend] PCI Express ASPM support should default to 'No'
Date: Sun, 27 Apr 2008 14:24:55 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       trivial@kernel.org
References: <alpine.LNX.1.00.0804272159520.2352@dragon.funnycrock.com>
In-Reply-To: <alpine.LNX.1.00.0804272159520.2352@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804271424.56188.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 27, 2008 1:07 pm Jesper Juhl wrote:
> From: Jesper Juhl <jesper.juhl@gmail.com>
>
> [This patch was previously submitted  23 April 2008 00:28]
>
> Andrew; if you could merge this in -mm it would be good, otherwise I'll
> just queue it up in the trivial tree for the next merge window.
>
>
> Running 'make oldconfig' I just noticed that PCIEASPM defaults to
> 'y' in Kconfig even though the feature is experimental and the
> help text recommends that if you are unsure you say 'n'.
> It seems to me that this really should default to 'n', not 'y'.
> The following patch makes that change. Please consider merging.
>
> Jesse Barnes commented on the patch that it "Seem reasonable".
> Shaohua Li also commented saying "Ok, I'm fine with the patch."
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

I already merged this into the PCI tree, I'll be sending the pull request 
soon.

Thanks,
Jesse
