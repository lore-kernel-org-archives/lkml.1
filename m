Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbXFFLju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbXFFLju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbXFFLjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:39:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:27931 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569AbXFFLji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:39:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=RvMJhV5DbjYE8xJm0MzOiKx8aQYx400sniJiZ8oDfp35QM4YVoALfcjobZWzFq+9YwKyccSMuRV8Y9FSaXYVeO/DcCCP8+imcAMJODyNH24qwm6/bqYSMVclXFhEMwbxSMGGfzDpoXPVTFiyVNahrZbPBDY/8cy4LoBNTuqwo/k=
Message-ID: <46669CE6.6060804@googlemail.com>
Date: Wed, 06 Jun 2007 13:39:18 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070525)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>
>   


Compile error here :

...

LD .tmp_vmlinux1
drivers/built-in.o: In function `acpi_init':
bus.c:(.init.text+0x249a): undefined reference to `pci_mmcfg_late_init'
make: *** [.tmp_vmlinux1] Error 1

....


http://frugalware.org/~crazy/other/mm/2.6.22-rc4-mm1/config

Regards,

Gabriel

