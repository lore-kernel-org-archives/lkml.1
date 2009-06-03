Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZFCVTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZFCVTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZFCVTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:19:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54080
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbZFCVTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:19:19 -0400
Date: Wed, 03 Jun 2009 14:19:19 -0700 (PDT)
Message-Id: <20090603.141919.261921857.davem@davemloft.net>
To: dbaryshkov@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, sfr@canb.auug.org.au,
       slapin@ossfans.org
Subject: Re: [PATCH 2/6] Add constants for the ieee 802.15.4/ZigBee stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090603105151.GA20508@doriath.ww600.siemens.net>
References: <1244021629-18409-3-git-send-email-dbaryshkov@gmail.com>
	<20090603.030826.03512651.davem@davemloft.net>
	<20090603105151.GA20508@doriath.ww600.siemens.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Wed, 3 Jun 2009 14:51:51 +0400

> Please check the updated patch. We do request several unused in this
> serie value (like AF_ZIGBEE), but we'd like for them to be merged ASAP
> as their are a part of ABI.

I don't allow anyone else to do this, and neither will I
allow it for you either.

Merge it when the patches that use them are submitted.

And if it happens, you just might to change AF_ZIGBEE if
that number is taken by another series of patches, that's
just how it is.  We don't reserve AF_* for people while
they're getting their stuff ready.

This decision is final.
