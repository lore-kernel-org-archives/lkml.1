Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXD0PaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXD0PaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbXD0PaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:30:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:59982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbXD0PaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:30:14 -0400
Date: Fri, 27 Apr 2007 18:30:16 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: What's in infiniband.git for 2.6.22
Message-ID: <20070427153016.GB1709@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <adaps5rro8v.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaps5rro8v.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <rdreier@cisco.com>:
> Subject: What's in infiniband.git for 2.6.22
> 
> Here's a short summary of what my plans for 2.6.22 are.  For
> reference, everything is in my git tree:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git

What about the mthca patch to use separate HW queues for kernel RC/UD/userspace RC?

-- 
MST
