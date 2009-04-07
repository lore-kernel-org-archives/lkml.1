Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZDGCIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZDGCIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZDGCH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:07:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44329
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbZDGCH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:07:56 -0400
Date: Mon, 06 Apr 2009 19:07:45 -0700 (PDT)
Message-Id: <20090406.190745.263215778.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0904061824410.4010@localhost.localdomain>
References: <20090406.175752.236260059.davem@davemloft.net>
	<alpine.LFD.2.00.0904061824410.4010@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Apr 2009 18:25:31 -0700 (PDT)

> 
> 
> The sky2 driver is buggered (by the previous pull, I presume). Some PCI 
> interaction. NULL pointer dereference at boot.

Fixed in the PCI tree, have you pulled that one yet?
