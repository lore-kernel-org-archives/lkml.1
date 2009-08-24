Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZHXX6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZHXX6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZHXX6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:58:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34375
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbZHXX6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:58:10 -0400
Date: Mon, 24 Aug 2009 16:58:23 -0700 (PDT)
Message-Id: <20090824.165823.252820713.davem@davemloft.net>
To: tilman@imap.cc
Cc: i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, hjlipp@web.de
Subject: Re: [PATCH RFC 0/6] Gigaset driver port to CAPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090821-patch-00.tilman@imap.cc>
References: <20090821-patch-00.tilman@imap.cc>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Fri, 21 Aug 2009 19:21:34 +0200 (CEST)

> the following set of six patches adds a configuration option to the
> Gigaset driver to interface to Kernel CAPI instead of the old
> ISDN4Linux subsystem. Although my unit test are not quite done yet
> I would appreciate comments.

>From my nieve perspective these changes look good, I hope
the ISDN folks look at them soon :-)
