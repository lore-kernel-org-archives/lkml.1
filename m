Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbYAAQZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbYAAQZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYAAQZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:25:38 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:34807 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbYAAQZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:25:37 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2008 11:25:37 EST
X-IronPort-AV: E=Sophos;i="4.24,230,1196658000"; 
   d="scan'208";a="46009219"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: improve remapping of vmalloc regions
Date: Tue, 1 Jan 2008 11:16:49 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801011116.49819.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Jan 2008 16:15:53.0629 (UTC) FILETIME=[95257CD0:01C84C91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick:

In Apr 2006, you sent around some patches 

> vm_insert_page and remap_pfn_range loops are really clever, bit
> probably asking a bit too much of most drivers. I was able to get
> rid of most of them without too much trouble.

http://lkml.org/lkml/2006/4/20/196

It doesn't seem like those made it into mainline - was there a reason why? (I 
looked around and didn't see anything).

Thanks
-Robin
