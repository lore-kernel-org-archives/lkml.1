Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbZF2QRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbZF2QRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZF2QQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:16:56 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:19146 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZF2QQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:16:56 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 12:16:55 EDT
X-SpamScore: -39
X-BigFish: VPS-39(zz1432R98dR936eN1805M9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4A48E564.6020904@am.sony.com>
Date: Mon, 29 Jun 2009 09:01:40 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
       cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 05/62] arch/powerpc: Remove unnecessary semicolons
References: <cover.1246173664.git.joe@perches.com> <a55afa18f8b7ba8343072a14d36a2e340e61e816.1246173680.git.joe@perches.com>
In-Reply-To: <a55afa18f8b7ba8343072a14d36a2e340e61e816.1246173680.git.joe@perches.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2009 16:01:43.0289 (UTC) FILETIME=[E56FA690:01C9F8D2]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2009 09:26 AM, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/powerpc/mm/tlb_hash64.c                 |    2 +-
>  arch/powerpc/oprofile/cell/vma_map.c         |    2 +-
>  arch/powerpc/platforms/powermac/cpufreq_64.c |    2 +-
>  arch/powerpc/platforms/powermac/pic.c        |    2 +-
>  arch/powerpc/platforms/ps3/system-bus.c      |    1 -
>  arch/powerpc/sysdev/fsl_rio.c                |    2 +-
>  arch/powerpc/sysdev/ppc4xx_pci.c             |    4 ++--
>  7 files changed, 7 insertions(+), 8 deletions(-)

For ps3/system-bus.c only.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>





