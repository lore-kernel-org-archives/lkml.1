Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbXIRTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbXIRTWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbXIRTV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:21:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42492
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbXIRTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:21:55 -0400
Date: Tue, 18 Sep 2007 12:21:50 -0700 (PDT)
Message-Id: <20070918.122150.124083496.davem@davemloft.net>
To: mchan@broadcom.com
Cc: vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
From: David Miller <davem@davemloft.net>
In-Reply-To: <1190145951.9540.230.camel@dell>
References: <1190141114.9540.216.camel@dell>
	<20070918.112337.74737433.davem@davemloft.net>
	<1190145951.9540.230.camel@dell>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Tue, 18 Sep 2007 13:05:51 -0700

> The bnx2 firmware changes quite frequently.  A new driver quite often
> requires new firmware to work correctly.  Splitting them up makes things
> difficult for the user.
> 
> The firmware in tg3 is a lot more mature and I don't expect it to
> change.  I think tg3 is better suited for using request_firmware().

Like I said, I think neither should change and the driver should
be fully functional when built statically into the kernel.

:-)
