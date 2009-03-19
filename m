Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZCSGpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZCSGpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZCSGov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:44:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52243
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754246AbZCSGou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:44:50 -0400
Date: Wed, 18 Mar 2009 23:44:37 -0700 (PDT)
Message-Id: <20090318.234437.86482822.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       kawk@users.sourceforge.net, hjlipp@web.de
Subject: Re: [PATCH] bas_gigaset: correctly allocate USB interrupt transfer
 buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090318-patch-01.tilman@imap.cc>
References: <20090318-patch-01.tilman@imap.cc>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Wed, 18 Mar 2009 16:58:50 +0100 (CET)

> bas_gigaset: correctly allocate USB interrupt transfer buffer
> 
> Every USB transfer buffer has to be allocated individually by kmalloc.
> 
> Impact: bugfix, no functional change
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> Tested-by: Kolja Waschk <kawk@users.sourceforge.net>

Patch applied to net-2.6, thanks.
