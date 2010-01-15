Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0AOQaO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932141Ab0AOQaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:30:12 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:62440 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0AOQaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:30:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bHfZgnYr3mU4oXx1yS3DIB3uBrikbap587UniAbzxygmRvgK5WtXOubnyoPAIzA9SH
         V5IP6VM4wR0DvQ2e5bM2lja5VZKdzXJcmyFX1vi6Ja9OOA4cC26Q2CbCNOmlYQf2qAjc
         naeX+MC+m0YUfrATlEah+kQQi1ZDr73PMLPJs=
Message-ID: <4B509840.1010808@gmail.com>
Date: Fri, 15 Jan 2010 08:30:56 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix a typo in pci-dma.c
References: <1263536176-9154-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1001151131070.30977@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1001151131070.30977@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/10 02:31, Jiri Kosina wrote:
> On Thu, 14 Jan 2010, Justin P. Mattock wrote:
>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> ---
>>   arch/x86/kernel/pci-dma.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
>> index 75e14e2..eec33a7 100644
>> --- a/arch/x86/kernel/pci-dma.c
>> +++ b/arch/x86/kernel/pci-dma.c
>> @@ -38,7 +38,7 @@ int iommu_detected __read_mostly = 0;
>>    * This variable becomes 1 if iommu=pt is passed on the kernel command line.
>>    * If this variable is 1, IOMMU implementations do no DMA translation for
>>    * devices and allow every device to access to whole physical memory. This is
>> - * useful if a user want to use an IOMMU only for KVM device assignment to
>> + * useful if a user wants to use an IOMMU only for KVM device assignment to
>>    * guests and not for driver dma translation.
>>    */
>
> Applied, thanks.
>

your welcome.

Justin P. Mattock
