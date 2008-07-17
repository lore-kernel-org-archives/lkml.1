Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYGQJD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYGQJD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYGQJDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:03:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:26280 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYGQJDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:03:19 -0400
Message-ID: <487F0AD1.6060200@mellanox.co.il>
Date: Thu, 17 Jul 2008 12:03:13 +0300
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Or Gerlitz <or.gerlitz@gmail.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] ***SPAM*** InfiniBand/RDMA merge plans for 2.6.27
References: <ada8ww5jbaf.fsf@cisco.com> <487B820E.4020002@mellanox.co.il>	<adahcarezdy.fsf@cisco.com>	<15ddcffd0807151220m37204055rf6890037b445bd34@mail.gmail.com> <ada7ibndjnj.fsf@cisco.com>
In-Reply-To: <ada7ibndjnj.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Right: in the test
>
> +	if ((dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_LOCAL_INV) &&
> +	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
> +	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
> +		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
>
> you will see that not all the bmme_flags required are set by FW 2.5.
>
>   
If someone is interested to get a FW that implement is please reply to me
We should have such a FW next week

Tziporet

