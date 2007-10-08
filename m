Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbXJHGdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbXJHGdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXJHGdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:33:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:12732 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXJHGdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:33:19 -0400
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: general@lists.openfabrics.org
Subject: Re: [ofa-general] Updated InfiniBand/RDMA merge plans for 2.6.24
Date: Mon, 8 Oct 2007 08:38:12 +0200
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
References: <adaodfdkv59.fsf@cisco.com>
In-Reply-To: <adaodfdkv59.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710080838.12778.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 October 2007 01:18, Roland Dreier wrote:
>  - XRC.  Given the length of the backlog above and the fact that a
>    first draft of this code has not been posted yet, I don't see any
>    way that we could have something this major ready in time.
> 
I posted the first draft patch set to the OpenFabrics list on September 18:

[ofa-general] [PATCH 0 of 5] XRC implementation patches (libibverbs, libmlx4, core, mlx4)   Jack Morgenstein
[ofa-general] [PATCH 1 of 5] libibverbs: XRC implementation   Jack Morgenstein
[ofa-general] [PATCH 2 of 5] libmlx4: XRC implementation   Jack Morgenstein
[ofa-general] [PATCH 3 of 5] core: XRC implementation for fd = -1 when opening an xrc domain   Jack Morgenstein
[ofa-general] [PATCH 4 of 5] core: XRC implementation -- add support for working with file descriptors   Jack Morgenstein
[ofa-general] [PATCH 5 of 5] mlx4: XRC implementation   Jack Morgenstein

The above patch set implements XRC for userspace verbs layer and below.
The Kernel-space verbs implementation (1 more patch) is finished,
but as yet untested.

- Jack
