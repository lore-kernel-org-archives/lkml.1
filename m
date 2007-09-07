Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbXIGA6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbXIGA6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 20:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964878AbXIGA62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 20:58:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:43847 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964864AbXIGA61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 20:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iysnJCpemYC8VxToEIfFssRr9O85fw5QMOSH41mIn4oAfFikClPgxYqv9SkuTn6a2+hqPljRRVhbRET5G5E+ZkGfqJM2dts0At/LQ3By4aerqusatOKTJqT0CUKTUpafOPzjVlLuxS1WThN5HmYdltS+KnF7LcijOibB5xW9Tr8=
Message-ID: <46E0A22B.6040202@gmail.com>
Date: Fri, 07 Sep 2007 09:58:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: bryan@arbores.ca
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Michal.k.k.Piotrowski@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca> <6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com> <46DBCB6C.8080206@gmail.com> <46E01601.9010907@arbores.ca>
In-Reply-To: <46E01601.9010907@arbores.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Woods wrote:

> The full dmesg and hdparm -I command output are attached.
> 
> I have received word from the vendor that the Stardom 2611 will do
> RAID0 or 1 under windows, but only RAID1 under Linux. (Their manual
> said it worked with Linux but failed to mention the RAID mode
> restriction: argh!)
> 
> They recommended the 2600 model for RAID0 with Linux, but that model
> is only SATA-I so I will probably go with alternate hardware.
> 
> The vendor also suggested the possibility of a firmware upgrade to
> the 2611 - I am still waiting to hear. I will post a followup if
> this happens.

If possible, please post dmesg from 2.6.22.5.

Thanks.

-- 
tejun
