Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYGOGo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYGOGo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYGOGow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:44:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:46271 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbYGOGov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:44:51 -0400
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: general@lists.openfabrics.org
Subject: Re: [ofa-general] ***SPAM*** InfiniBand/RDMA merge plans for 2.6.27
Date: Tue, 15 Jul 2008 09:45:34 +0300
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
References: <ada8ww5jbaf.fsf@cisco.com>
In-Reply-To: <ada8ww5jbaf.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807150945.34571.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008 08:16, Roland Dreier wrote:
> HW specific:
> 
>  - Yevgeny's mlx4 changes.  We'll see how much time is left after I
>    get done with XRC (which is before this on my list) but to be
>    honest I'm not sure how mergeable a lot of this is without the
>    mlx4_en patches that actually use it.
> 
>  - I've been working on memory management extensions support for mlx4,
>    but I'm not sure if it will be ready in time.  Firmware for this
>    may not be released for a while so it ain't urgent anyway.
> 
Roland, what about the fw diagnostic patch for the mlx4 driver?
http://lists.openfabrics.org/pipermail/general/2008-June/051655.html

Can you put this in 2.6.27, too?

- Jack
