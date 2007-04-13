Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbXDMQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbXDMQcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXDMQcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:32:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:15661 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbXDMQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=djL3fTn+wr72+pKwPryJ6EcDdMHCnwZ1ExR3z55TdXCR5MrUDbPrn/eBDnyxqcR70QN77CK9vpitHuX8pYGbnSUs+GBHvA4BBIfPjH3ORAglioQ/cdezrrA4oZddmzMmTVysdGuXjqbRXDXfUKlr6jM/7Wg7jJ0Hu9im9hcnqqc=
Message-ID: <6bffcb0e0704130932q215a2deby91141c8d3c78bde7@mail.gmail.com>
Date: Fri, 13 Apr 2007 18:32:14 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [3/4] 2.6.21-rc5: known regressions (v2)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org
In-Reply-To: <20070330213220.GO14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <20070330213220.GO14134@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/03/07, Adrian Bunk <bunk@stusta.de> wrote:
> Subject    : suspend to disk hangs  (skge)
> References : http://lkml.org/lkml/2007/3/27/212
> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Caused-By  : Stephen Hemminger <shemminger@linux-foundation.org>
>              commit a504e64ab42bcc27074ea37405d06833ed6e0820
> Status     : unknown

This problem is fixed in 2.6.21-rc6-git5 (commit
692412b31ffb5df00197ea591dd635fc07506c02).

Huge thanks to Stephen.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
