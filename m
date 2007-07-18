Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbXGRIrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbXGRIrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXGRIrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:47:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:62848 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbXGRIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:47:12 -0400
Message-ID: <469DD3FA.305@mellanox.co.il>
Date: Wed, 18 Jul 2007 11:48:58 +0300
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
CC: Tziporet Koren <tziporet@dev.mellanox.co.il>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: Further 2.6.23 merge plans...
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>	<adazm1urji8.fsf@cisco.com> <20070717214417.GE17168@mellanox.co.il>	<469DC29C.3070205@mellanox.co.il> <20070718073831.GE1115@mellanox.co.il>
In-Reply-To: <20070718073831.GE1115@mellanox.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
>> As far as I know Intel run with SA cache enabled on large clusters with
>> Intel MPI
>>     
>
> With OFED 1.2 version of the code, right?
>
>   
Yes.
But maybe they also used the new module - Sean?
