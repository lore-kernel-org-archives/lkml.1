Return-Path: <linux-kernel-owner+w=401wt.eu-S1031131AbXDQS4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031131AbXDQS4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031138AbXDQS4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:56:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32785
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031131AbXDQS4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:56:00 -0400
Date: Tue, 17 Apr 2007 11:56:02 -0700 (PDT)
Message-Id: <20070417.115602.35506934.davem@davemloft.net>
To: seokmann.ju@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com,
       ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
References: <20070417024107.GE16469@dmccrory-d810.qlogic.org>
	<20070416.220208.94071670.davem@davemloft.net>
	<A6970E9A290F3F4682E1EAD0EA14F32BDF5854@AVEXCH2.qlogic.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Date: Tue, 17 Apr 2007 11:28:07 -0700

> Hello David,
> On Mon 4/16/2007 10:02 PM, David Miller wrote:
> > > I'm in transit for a redeye to NY so I won't be able to modify the 
> > > patch, If you would be amenable to the above, Seokmann, could you 
> > > rework the patch?
> > 
> > Thanks guys.
> Here, I've attached updated patch. Please take this.
> Sorry for late.

Actually, I misunderstood the patch.

If SPARC provides the port and node WWN numbers in the OFW properties
the driver should load properly.

NAK, I reject this patch.
