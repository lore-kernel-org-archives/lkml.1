Return-Path: <linux-kernel-owner+w=401wt.eu-S1763972AbXHCVZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763972AbXHCVZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXHCVZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:25:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46759
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757736AbXHCVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:25:06 -0400
Date: Fri, 03 Aug 2007 14:25:04 -0700 (PDT)
Message-Id: <20070803.142504.21593407.davem@davemloft.net>
To: drepper@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, rth@redhat.com
Subject: Re: arch maintainers: define O_CLOEXEC correctly!
From: David Miller <davem@davemloft.net>
In-Reply-To: <46B3613C.60007@redhat.com>
References: <46B3613C.60007@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Fri, 03 Aug 2007 10:09:16 -0700

> Affected as far as I know:
> 
> Alpha:   probably needs value 010000000
> 
> Sparc*:         -"-           0x400000

I've fixed sparc, thanks for reporting this.
