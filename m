Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZGNGiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZGNGiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 02:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZGNGiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 02:38:17 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:25530
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753705AbZGNGiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 02:38:16 -0400
Message-ID: <4A5C27D4.5040204@panasas.com>
Date: Tue, 14 Jul 2009 09:38:12 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and remove
 EXPERIMENTAL dependency, since udev depends on BSG.
References: <1247513973-24899-1-git-send-email-john@stoffel.org> <19035.36432.181354.977939@stoffel.org>
In-Reply-To: <19035.36432.181354.977939@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 06:38:15.0797 (UTC) FILETIME=[AACC0250:01CA044D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 10:43 PM, John Stoffel wrote:
>>>>>> "John" == John Stoffel <john@stoffel.org> writes:
> 
> Dammit, I messed up here sending this patch.  I've just edited the
> subject line and re-sent it with a bit more description.  I think this
> patch is perfectly good to go into 2.6.31 right now, esp since it's
> not changing code, just whether the code is turned on by default from
> now on.
> 

I would like it if you'd also CC stable@kernel.org on this patch. As this
condition is already true for distros in the field.

[Though distros have enabled it for years and every one is using the distro's
 .config when compiling their own Kernel, right?]

> Thanks,
> John
> 
> 

Thanks
Boaz
