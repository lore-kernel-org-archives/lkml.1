Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZCJMZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZCJMZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZCJMZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:25:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35885
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754787AbZCJMZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:25:27 -0400
Date: Tue, 10 Mar 2009 05:25:13 -0700 (PDT)
Message-Id: <20090310.052513.106958818.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pebolle@tiscali.nl,
       hjlipp@web.de
Subject: Re: [PATCH 2/2] gigaset: Kconfig cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090307-patch-02.tilman@imap.cc>
References: <20090307-patch-00.tilman@imap.cc>
	<20090307-patch-02.tilman@imap.cc>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sat,  7 Mar 2009 23:11:02 +0100 (CET)

> Streamline dependencies and remove some obsolete or redundant comments
> in the Gigaset ISDN driver's Kconfig file. In particular, remove the
> strong warning against the GIGASET_UNDOCREQ option, as in seven years
> of existence, the code in question has never been reported to cause
> any harm.
> 
> Impact: Kconfig cleanup, no functional change
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Also applied, thanks.
