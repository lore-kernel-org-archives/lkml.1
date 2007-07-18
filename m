Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbXGRHiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbXGRHiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760580AbXGRHiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:38:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:13877 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316AbXGRHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:38:24 -0400
Date: Wed, 18 Jul 2007 10:38:31 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Tziporet Koren <tziporet@dev.mellanox.co.il>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: Further 2.6.23 merge plans...
Message-ID: <20070718073831.GE1115@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	<adazm1urji8.fsf@cisco.com> <20070717214417.GE17168@mellanox.co.il>
	<469DC29C.3070205@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469DC29C.3070205@mellanox.co.il>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Tziporet Koren <tziporet@dev.mellanox.co.il>:
> Subject: Re: [ofa-general] Re: Further 2.6.23 merge plans...
> 
> Michael S. Tsirkin wrote:
> >We have the patches applied in ofed 1.2.c with default module parameter set
> >to caching disabled (ofed 1.2 had a different version of the patches, but
> >caching is disabled by default there, too). At least
> >in this configuration (caching disabled), all issues I've seen seem to be
> >fixed now, and tests seem to be running smoothly.
>
> As far as I know Intel run with SA cache enabled on large clusters with 
> Intel MPI

With OFED 1.2 version of the code, right?

-- 
MST
