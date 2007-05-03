Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXECKKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXECKKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXECKKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:10:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59089
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbXECKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:10:52 -0400
Date: Thu, 03 May 2007 03:10:52 -0700 (PDT)
Message-Id: <20070503.031052.106746215.davem@davemloft.net>
To: dhowells@redhat.com
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       geert@linux-m68k.org
Subject: Re: [PATCH 1/2] AFS: Make the match_*() functions take const
 options
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070501174747.19112.1985.stgit@warthog.cambridge.redhat.com>
References: <20070501174747.19112.1985.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 01 May 2007 18:47:47 +0100

> Make the match_*() functions take a const pointer to the options table and
> make strings pointers in the options table const too.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

I'll take this, applied, thanks David.
