Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbXBKWIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbXBKWIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932575AbXBKWIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:08:40 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:4798 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbXBKWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FTGa4OCM/p8QqZiPjmH232i+8GHhtUywJSR9ixzHxt/W7IZmL1RWcJTIX87kwkfB7DXGhbW6E9g/rPFrzB7+wCkpPpbBzWoFQ/sPqaytz5Vvm+Es5fNHobYs/2DKFziID4Sy/HeX0G/AgkW5lHK8dDRvZadbiSn2Y5GVjGvcU0g=
Message-ID: <45CF93D1.9080009@gmail.com>
Date: Sun, 11 Feb 2007 17:08:17 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates 1 of 3
References: <20070210010914.GA19717@havoc.gtf.org> <20070210054629.GA4395@gentoox2.trippelsdorf.de>
In-Reply-To: <20070210054629.GA4395@gentoox2.trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote:
> This update breaks sata_via on my VIA K8T800Pro machine:
>  
>  sata_via 0000:00:0f.0 : failed to iomap PCI BAR 0
>  sata_via 0000:00:0f.0 : out of memory
>  sata_via probe of 0000:00:0f.0 failed with error -12

Please post full dmesg and the result of 'lspci -nnvvvxxx'.

-- 
tejun
