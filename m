Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbXEVXOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbXEVXOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbXEVXOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:14:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756332AbXEVXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:14:38 -0400
Date: Tue, 22 May 2007 16:14:40 -0700 (PDT)
Message-Id: <20070522.161440.38321857.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, netdeg@vger.kernel.org
Subject: Re: [PATCH 2/2] AF_RXRPC: Make call state names available if
 CONFIG_PROC_FS=n
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070522125610.27625.60126.stgit@warthog.cambridge.redhat.com>
References: <20070522125605.27625.42682.stgit@warthog.cambridge.redhat.com>
	<20070522125610.27625.60126.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 22 May 2007 13:56:10 +0100

> Make the call state names array available even if CONFIG_PROC_FS is disabled
> as it's used in other places (such as debugging statements) too.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Also applied, thanks David.
