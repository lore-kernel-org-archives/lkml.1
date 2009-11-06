Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZKFBkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZKFBkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZKFBkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:40:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42177
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940AbZKFBka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:40:30 -0500
Date: Thu, 05 Nov 2009 17:40:55 -0800 (PST)
Message-Id: <20091105.174055.161804502.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, marcel@holtmann.org,
       torgny.johansson@gmail.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091106115554.44622e53.sfr@canb.auug.org.au>
References: <20091106115554.44622e53.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 6 Nov 2009 11:55:54 +1100

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/usb/cdc_ether.c between commit
> 3a19d56c71bd3a08412d609d219ac8eec0819166 ("cdc_ether: additional Ericsson
> MBM PID's to the whitelist") from the net-current tree and commit
> e1e499eef2200c2a7120c9ebf297d48b195cf887 ("usbnet: Use wwan%d interface
> name for mobile broadband devices") from the net tree.
> 
> Context changes.  I fixed it up (see below) and can carry it as
> necessary.  This fix may not be completely correct ...

Thanks I'll take a look at this when merging net-2.6 into
net-next-2.6 later tonight.
