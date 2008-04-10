Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYDJBWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYDJBWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 21:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYDJBW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 21:22:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47145
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbYDJBW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 21:22:27 -0400
Date: Wed, 09 Apr 2008 18:22:28 -0700 (PDT)
Message-Id: <20080409.182228.193699767.davem@davemloft.net>
To: lkml@rtr.ca
Cc: yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <47FD590C.5020003@rtr.ca>
References: <47FD138B.2060801@rtr.ca>
	<20080409.152933.132174258.davem@davemloft.net>
	<47FD590C.5020003@rtr.ca>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <lkml@rtr.ca>
Date: Wed, 09 Apr 2008 20:02:20 -0400

> Really, folks.  Bug reports are intended to *help* the developers,
> not something to be thrown back in their faces.

It's a two way street, we asked for a bisect which helps us a lot.

In fact, lately I notice a strong unwillingness to bisect on your
part, in particular.
