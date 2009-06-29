Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZF2SO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZF2SO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZF2SOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:14:20 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:7716 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZF2SOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:14:19 -0400
Subject: Re: [PATCH 35/62] drivers/pci/pcie/aer/ecrc.c: Remove unnecessary
 semicolons
From: Andrew Patterson <andrew.patterson@hp.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-pci@vger.kernel.org
In-Reply-To: <e33e260ba10929dbf148ced4764de433b7bf5879.1246173682.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	 <e33e260ba10929dbf148ced4764de433b7bf5879.1246173682.git.joe@perches.com>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 12:15:27 -0600
Message-Id: <1246299328.8234.327.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 09:26 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/pci/pcie/aer/ecrc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aer/ecrc.c b/drivers/pci/pcie/aer/ecrc.c
> index ece97df..a928d8a 100644
> --- a/drivers/pci/pcie/aer/ecrc.c
> +++ b/drivers/pci/pcie/aer/ecrc.c
> @@ -106,7 +106,7 @@ void pcie_set_ecrc_checking(struct pci_dev *dev)
>  		disable_ecrc_checking(dev);
>  		break;
>  	case ECRC_POLICY_ON:
> -		enable_ecrc_checking(dev);;
> +		enable_ecrc_checking(dev);
>  		break;
>  	default:
>  		return;

Acked-by: Andrew Patterson <andrew.patterson@hp.com>

-- 
Andrew Patterson
Hewlett-Packard

