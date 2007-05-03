Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXECKOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXECKOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXECKOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:14:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59105
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbXECKOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:14:08 -0400
Date: Thu, 03 May 2007 03:14:09 -0700 (PDT)
Message-Id: <20070503.031409.55861440.davem@davemloft.net>
To: rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] NET: Delete unused header file net/ipv4/tcp_yeah.h.
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705011450020.23352@localhost.localdomain>
References: <Pine.LNX.4.64.0705011450020.23352@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@mindspring.com>
Date: Tue, 1 May 2007 14:52:14 -0400 (EDT)

> Delete the apparently unused header file net/ipv4/tcp_yeah.h.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Applied, thanks.

> kind of odd that this header file is unreferenced since there's a
> matching source file net/ipv4/tcp_yeah.c.  oh, well ...

Stephen Hemminger cleaned up this code a lot and I think
killing this header file was just merely forgotten.
