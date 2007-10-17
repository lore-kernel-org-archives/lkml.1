Return-Path: <linux-kernel-owner+w=401wt.eu-S935160AbXJQLSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935160AbXJQLSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760769AbXJQLSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:18:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41689
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758011AbXJQLSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:18:10 -0400
Date: Wed, 17 Oct 2007 04:18:23 -0700 (PDT)
Message-Id: <20071017.041823.48807727.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071017111146.GW5043@kernel.dk>
References: <20071017110142.GU5043@kernel.dk>
	<20071017.041004.21594558.davem@davemloft.net>
	<20071017111146.GW5043@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 17 Oct 2007 13:11:46 +0200

> On Wed, Oct 17 2007, David Miller wrote:
> > Jens, please also add the following on top of Fujita-san's most recent
> > sparc64 patch and we should be good to go.
> 
> Awesome, thanks. And sorry for messing up sparc64.

Don't worry, I'll keep breaking your network interfaces
just to keep things even :-)
