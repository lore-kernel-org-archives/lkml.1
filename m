Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYJ2Xkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYJ2Xkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYJ2Xkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:40:41 -0400
Received: from nebensachen.de ([195.34.83.29]:50571 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJ2Xkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:40:40 -0400
X-Hashcash: 1:20:081029:linville@tuxdriver.com::FHWZdvQORflurFly:0000000000000000000000000000000000000003FW4
X-Hashcash: 1:20:081029:davem@davemloft.net::rjOzxm4OnJsOXc51:0000000000000000000000000000000000000000000pUw
X-Hashcash: 1:20:081029:linux-wireless@vger.kernel.org::v9m2Op4d/pr+YoYp:0000000000000000000000000000000AIHI
X-Hashcash: 1:20:081029:netdev@vger.kernel.org::QwshER+gRnTHYC6T:00000000000000000000000000000000000000051fd
X-Hashcash: 1:20:081029:linux-kernel@vger.kernel.org::hhDfxI0yD86II/JN:0000000000000000000000000000000001HwB
From: Elias Oltmanns <eo@nebensachen.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-10-29
References: <20081029231855.GD3485@tuxdriver.com>
Date: Thu, 30 Oct 2008 00:40:09 +0100
In-Reply-To: <20081029231855.GD3485@tuxdriver.com> (John W. Linville's message
	of "Wed, 29 Oct 2008 19:18:55 -0400")
Message-ID: <87iqrb2co6.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org> wrote:
> Dave,
>
> Another quick round of fixes intended for 2.6.28...
>
> This includes fixes for bugs 11749 and 11845, fixes a reset-related
> regression in ath5k, fixes a Kconfig-related error for rt2x00, and
> fixes some sparse warnings and a possible buffer overrun in libertas.
> Also, it corrects a spelling error and marks Bob Copeland as an
> ath5k maintainer.
>
> Please let me know if there are problems!
>
> Thanks,
>
> John
>
> ---
>
> Individual patches are available here:
>
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/
>
> ---
>
> The following changes since commit 882716604ecf388b2ff09bc76eb2a752aa9cc76b:
[...]
> Elias Oltmanns (1):
>       ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular

Pity, I just posted a *nicer* version of that patch for 2.6.28-rc2.
Well, it doesn't really matter all that much, I suppose.

Regards,

Elias
