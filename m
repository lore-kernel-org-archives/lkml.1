Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0CIXHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:07:52 -0500
Received: from xenotime.net ([72.52.64.118]:44681 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755054Ab0CIXHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:07:49 -0500
Message-ID: <4B96D4BF.4080006@xenotime.net>
Date: Tue, 09 Mar 2010 15:07:43 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: akpm@linux-foundation.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH -mm 2/3] Documentation: remove the PCI DMA API description
 in DMA-API.txt
References: <1268110389-12444-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1268110389-12444-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1268110389-12444-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/10 20:53, FUJITA Tomonori wrote:
> - remove the PCI DMA API description in DMA-API.txt
> - remove the descriptions of dma_unmap macros since
>   PCI-DMA-mapping.txt has the same description.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  Documentation/DMA-API.txt |  152 +++++----------------------------------------
>  1 files changed, 15 insertions(+), 137 deletions(-)
> 
> diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
> index 0fc5728..5e018f6 100644
> --- a/Documentation/DMA-API.txt
> +++ b/Documentation/DMA-API.txt

Reviewed-by: Randy Dunlap <rdunlap@xenotime.net>


Thanks.

-- 
~Randy
