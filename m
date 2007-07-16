Return-Path: <linux-kernel-owner+w=401wt.eu-S1761750AbXGPVbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761750AbXGPVbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761314AbXGPVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:31:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44629
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758312AbXGPVbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:31:06 -0400
Date: Mon, 16 Jul 2007 14:31:06 -0700 (PDT)
Message-Id: <20070716.143106.35661927.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: jeremy@goop.org, ak@suse.de, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, lenb@kernel.org, randy.dunlap@oracle.com,
       viro@zeniv.linux.org.uk, arnd@arndb.de
Subject: Re: [patch 6/7] Add common orderly_poweroff()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070716125223.249a6914.akpm@linux-foundation.org>
References: <20070510235708.155502000@goop.org>
	<20070511000028.446470000@goop.org>
	<20070716125223.249a6914.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 16 Jul 2007 12:52:23 -0700

> Dave, those changes hit mainline without ever having appeared in the
> sparc-2.6.git tree, afaict.

It's been in there for more than a week.

