Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZLCRnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZLCRnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbZLCRns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:43:48 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:40674 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZLCRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DSn1IKD20q22xO2hFdUkq5W7caUIl3QQsjg4cbFT2oqeerpTbBo0B/4DSjKORH+UbC
         l8SsHLAHXehZs3Y/ZJ+K9hRygumJ/tqAFxFw81Hgx0S9mffof5oHamdoifMPHVxXK+Ai
         qMBoxo+Vf8aimmXL925jknd7TCcNSeGCcMF+M=
Message-ID: <4B17F8D5.50703@garzik.org>
Date: Thu, 03 Dec 2009 12:43:49 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, rjw@sisk.pl, ddutile@redhat.com,
       kaneshige.kenji@jp.fujitsu.com, khc@pm.waw.pl,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 1/2 v2] pci: change PCI nomenclature in drivers/pci/ (comment
 changes)
References: <20091203114914.24905.67372.sendpatchset@localhost.localdomain> <20091203114923.24905.48449.sendpatchset@localhost.localdomain> <4B17EFA7.8040504@redhat.com>
In-Reply-To: <4B17EFA7.8040504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 12:04 PM, Stefan Assmann wrote:
> repost with typo "Debuging" fixed as in patch #2.
>
>
> From: Stefan Assmann<sassmann@redhat.com>
>
> Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
> terms listed in the "Trademark and Logo Usage Guidelines".
> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf
>
> Patch is limited to drivers/pci/ and changes concern comments only.
>
> Signed-off-by: Stefan Assmann<sassmann@redhat.com>
> ---
>   drivers/pci/hotplug/shpchp.h       |    2 +-
>   drivers/pci/intel-iommu.c          |    6 +++---
>   drivers/pci/intr_remapping.c       |    2 +-
>   drivers/pci/pci.c                  |    6 +++---
>   drivers/pci/pcie/aer/aer_inject.c  |    4 ++--
>   drivers/pci/pcie/aer/aerdrv.c      |    2 +-
>   drivers/pci/pcie/aer/aerdrv_acpi.c |    2 +-
>   drivers/pci/pcie/aer/aerdrv_core.c |    6 +++---
>   drivers/pci/pcie/aspm.c            |    4 ++--
>   drivers/pci/search.c               |    6 +++---
>   10 files changed, 20 insertions(+), 20 deletions(-)

Thanks for splitting this up.  These are definitely much more 
"digestable" patches.

I don't have any objections to these patches, except for previous 
comments about code churn itself.  Up to Jesse...

	Jeff



