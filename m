Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZAFL1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZAFL1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 06:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZAFL1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 06:27:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:9442 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZAFL1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 06:27:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=b7Ol3dgGxDMaZ8KbRV6TbDdnAmbkSpz1QfU2qzOhzu0LoAOYDxGJKzT4J1zQwsL9Bm
         8qDEXtOFe/TlVLnIYuJxAcG1l/S0nddO4rlLaKmEP9jk1RntGqf3hGOCUQch0ExhLn8v
         eY+7SuU+oKh+pHZcxSnjWcJukFeY9VeTSq8os=
Message-ID: <49633FFF.9050804@gmail.com>
Date: Tue, 06 Jan 2009 12:26:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       weidong.han@intel.com
Subject: Re: mmotm 2009-01-05-12-50 uploaded
References: <200901052050.n05Kox9j012519@imap1.linux-foundation.org> <49628A1E.9080003@gmail.com> <alpine.LRH.1.10.0901060247580.24105@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0901060247580.24105@twin.jikos.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 5 Jan 2009, Jiri Slaby wrote:
> 
>>> The mm-of-the-moment snapshot 2009-01-05-12-50 has been uploaded
>> it fails to build here due to this link error:
>> drivers/built-in.o: In function `alloc_iommu':
>> (.text+0xf1bf): undefined reference to `iommu_calculate_agaw'
> 
> This is not a problem of mmotom, the same applies for Linus' tree. The 
> patch exists [1], but it seems to be queued in Ingo's tree still.
> 
> [1] http://lkml.org/lkml/2009/1/4/35

Ok, thanks Jiri.
