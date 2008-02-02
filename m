Return-Path: <linux-kernel-owner+w=401wt.eu-S1762252AbYBBI7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762252AbYBBI7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 03:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbYBBI7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 03:59:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:36902 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbYBBI7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 03:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sQz3w17Z1U4hEobANYAYhjAz5LAEPKAT4Re9S/R7klUNOKImFZNtHvH4emJ+23SnR/Ihg7mO1n6VorkW7WUBKvW77f4JxciSSsgj6OqGI8szJd2yPFUgrWqRpxCsocR7dULjTJhMwH5lG/PbIqDBj/kYDFT1sqLVRO+pv9d8huo=
Message-ID: <47A430DA.7000104@gmail.com>
Date: Sat, 02 Feb 2008 17:59:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Evgen L <evgen@b-k.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: intel ahci problem
References: <479F41BB.5020800@b-k.ru>
In-Reply-To: <479F41BB.5020800@b-k.ru>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgen L wrote:
> Hi all
> 
> I have a problem with my Intel SR1550 server (S5000PAL motheboard,
> SATA/SAS controller, 5 SATA HDD Seagate ST9120822AS ).
> The four drivers are in two md raid1, which striping by lvm and one
> drive used separately. I have problem like below with two different
> drives (ata3 or ata4) and ata5. I look problem like this with RedHat 
> 2.6.18-53 kernel, 2.6.24-rc8, and today 2.6.24-git5. I reading about any
> problems like this in lkml.org. There can be this message will help to
> fix this issue.
> The complete dmesg in attachment.

Please post full dmesg including boot log and errors and the result
"lspci -nn".

-- 
tejun
