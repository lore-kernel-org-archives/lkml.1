Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZA0GVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZA0GVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 01:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZA0GVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 01:21:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53581
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbZA0GVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 01:21:22 -0500
Date: Mon, 26 Jan 2009 22:21:19 -0800 (PST)
Message-Id: <20090126.222119.121000067.davem@davemloft.net>
To: rdreier@cisco.com
Cc: divy@chelsio.com, swise@opengridcomputing.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 2.6.30] cxgb3 - notify iWARP of chip resets
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaeiyqymot.fsf@cisco.com>
References: <497DF609.9000600@chelsio.com>
	<adaeiyqymot.fsf@cisco.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 26 Jan 2009 09:57:54 -0800

>  > I'm submitting 2 patches against cxgb3 and iw_cxgb3 respectively.
>  > They are built against net-next-2.6.
>  > The first patch adds a notification mechanism to cxgb3 to alert
>  > the upper layer drivers (iWARP and iSCSI) of a chip reset.
>  > 
>  > The second patch adds the handler for such an event in the iWARP driver.
>  > 
>  > Since the second patch depends on the first one, I submit them together,
>  > even though the second patch should be submitted against Roland's tree.
> 
> simplest thing is for Dave to merge both, and I'm fine with that.

Ok, I'll take care of this.
