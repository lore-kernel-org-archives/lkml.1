Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbXGRHev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbXGRHev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757586AbXGRHdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:33:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:8211 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204AbXGRHdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:33:04 -0400
Message-ID: <469DC29C.3070205@mellanox.co.il>
Date: Wed, 18 Jul 2007 10:34:52 +0300
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: Further 2.6.23 merge plans...
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>	<adazm1urji8.fsf@cisco.com> <20070717214417.GE17168@mellanox.co.il>
In-Reply-To: <20070717214417.GE17168@mellanox.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> We have the patches applied in ofed 1.2.c with default module parameter set to
> caching disabled (ofed 1.2 had a different version of the patches, but caching
> is disabled by default there, too). At least in this configuration
> (caching disabled), all issues I've seen seem to be fixed now, and tests seem to
> be running smoothly.
>   
As far as I know Intel run with SA cache enabled on large clusters with 
Intel MPI

Tziporet

