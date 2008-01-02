Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYABFEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYABFEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 00:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYABFEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 00:04:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:31057 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYABFEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 00:04:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,232,1196668800"; 
   d="scan'208";a="355487534"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6 patch] #if 0 dma_async_memcpy_buf_to_buf()
Date: Tue, 1 Jan 2008 21:04:33 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03B06B38@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080101142531.787084d5@the-village.bc.nu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] #if 0 dma_async_memcpy_buf_to_buf()
Thread-Index: AchMg17G+JEKXeGjSxmAr1/b0UonrQAeSipg
References: <20080101134924.GR2360@does.not.exist> <20080101142531.787084d5@the-village.bc.nu>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Adrian Bunk" <bunk@kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Jan 2008 05:04:34.0515 (UTC) FILETIME=[F7563230:01C84CFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
>Sent: Tuesday, January 01, 2008 6:26 AM
>To: Adrian Bunk
>Cc: Nelson, Shannon; Williams, Dan J; linux-kernel@vger.kernel.org
>Subject: Re: [2.6 patch] #if 0 dma_async_memcpy_buf_to_buf()
>
>On Tue, 1 Jan 2008 15:49:24 +0200
>Adrian Bunk <bunk@kernel.org> wrote:
>
>> This patch #if 0's the unused dma_async_memcpy_buf_to_buf().
>> 
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>NAK. Yet again you are trying to remove bits of APIs in ways that make
>no sense.
>

Yes, this should be a NAK.

Thank you Alan.

sln
