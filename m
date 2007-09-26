Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXIZBFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXIZBFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXIZBFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:05:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34999
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbXIZBF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:05:29 -0400
Date: Tue, 25 Sep 2007 18:05:28 -0700 (PDT)
Message-Id: <20070925.180528.59673273.davem@davemloft.net>
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: queued patches for SCSI for 2.6.24
From: David Miller <davem@davemloft.net>
In-Reply-To: <1190768402.8707.20.camel@localhost.localdomain>
References: <1190768402.8707.20.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Tue, 25 Sep 2007 20:00:02 -0500

> David Miller (1):
>       esp: fix instance numbering.

I'd like to request that this one goes into 2.6.23 as
it is a bug fix and the bug confuses users.

Thanks.
