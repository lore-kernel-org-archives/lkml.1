Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbYDDTju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbYDDTju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760664AbYDDTj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:39:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47745
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760641AbYDDTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:39:24 -0400
Date: Fri, 04 Apr 2008 12:39:24 -0700 (PDT)
Message-Id: <20080404.123924.214795240.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080404063359.GA13309@havoc.gtf.org>
References: <20080404063359.GA13309@havoc.gtf.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 4 Apr 2008 02:33:59 -0400

> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-davem

I think we need to defer the Tulip davicom ID removal patch, because
the tulip driver is the only one that works on sparc64 for davicom
chips, dmfe does not.

That's a regression, so I can't pull this in as-is.

I'm happy to discuss the davicom+sparc64 issue, but for now if
you could simply give me a tree which contains the other
bug fixes we can integrate those now.

Thanks!
