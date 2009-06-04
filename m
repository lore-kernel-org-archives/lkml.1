Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbZFDAyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbZFDAyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZFDAya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:54:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39714
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294AbZFDAya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:54:30 -0400
Date: Wed, 03 Jun 2009 17:54:30 -0700 (PDT)
Message-Id: <20090603.175430.193109210.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next 1/2] cxgb3: Update FW to 7.4.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A27099E.3070202@chelsio.com>
References: <20090603161910.17960.28171.stgit@speedy5>
	<4A27099E.3070202@chelsio.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 03 Jun 2009 16:39:10 -0700

> Please drop this patch. The FW image is corrupted.
> I reposted the patch with the correct image.

Will do.

Could you please address Ben's request that you use request_firmware()
for that in-source firmware blob you added for new PHY support
recently?  I never saw you even reply to his posting stating how you
intend to deal with that problem, and that's not acceptable. :-)

