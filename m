Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325Ab0AWJSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0AWJSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487Ab0AWJSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:18:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38047
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab0AWJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:18:13 -0500
Date: Sat, 23 Jan 2010 01:18:24 -0800 (PST)
Message-Id: <20100123.011824.39481030.davem@davemloft.net>
To: jan.kiszka@web.de
Cc: isdn@linux-pingi.de, linux-kernel@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de, isdn4linux@listserv.isdn4linux.de,
       netdev@vger.kernel.org
Subject: Re: [PATCH 00/31] CAPI: Major rework, tons of bug fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>
Date: Sat, 23 Jan 2010 00:03:26 +0100

> First of all sorry if I'm breaking the correct flow of ISDN patches, but
> I'm under the impression that things currently get merged directly via
> Dave, right?
> 
> This series can also be pulled from
> 
> 	git://git.kiszka.org/linux-2.6.git capi

This doesn't pull cleanly into net-next-2.6 which is where I would
be adding it.

There were a bunch of changes to the procfs code here and it conflicts
with your changes.

Please do a merge and sort things out, and then send another
pull request.

Thanks.
