Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZFDAtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZFDAtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZFDAtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:49:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54038
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578AbZFDAtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:49:20 -0400
Date: Wed, 03 Jun 2009 17:49:21 -0700 (PDT)
Message-Id: <20090603.174921.184497846.davem@davemloft.net>
To: dbaryshkov@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, sfr@canb.auug.org.au,
       slapin@ossfans.org
Subject: Re: [PATCH 2/6] Add constants for the ieee 802.15.4/ZigBee stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090603231537.GB32561@doriath.ww600.siemens.net>
References: <20090603105151.GA20508@doriath.ww600.siemens.net>
	<20090603.141919.261921857.davem@davemloft.net>
	<20090603231537.GB32561@doriath.ww600.siemens.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Thu, 4 Jun 2009 03:15:37 +0400

> From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Date: Thu, 4 Jun 2009 03:09:40 +0400
> Subject: [PATCH 2/6] Add constants for the ieee 802.15.4/ZigBee stack
> 
> IEEE 802.15.4/ZigBee stack requires several constants to be defined/adjusted.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Sergey Lapin <slapin@ossfans.org>

Looks a lot better, except that there is no reason to mention
ZigBee anymore in the commit message I guess :-)

Once all the feedback is sorted out, please make a formal
resubmission of the entire series.

Thank you.
