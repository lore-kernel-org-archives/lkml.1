Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZCMW2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZCMW2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZCMW2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:28:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43117
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbZCMW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:28:43 -0400
Date: Fri, 13 Mar 2009 15:28:29 -0700 (PDT)
Message-Id: <20090313.152829.165834070.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: scott@canonical.com, linux-kernel@vger.kernel.org,
       bridge@lists.linux-foundation.org
Subject: Re: [PATCH 01/31] bridge: Auto-load bridge module when socket
 opened.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090313151200.1cc16255@nehalam>
References: <74b87ec3359e6e65d59cd6fb62a83fb469e6c8ae.1236702228.git.scott@canonical.com>
	<20090313.142718.21189207.davem@davemloft.net>
	<20090313151200.1cc16255@nehalam>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Fri, 13 Mar 2009 15:12:00 -0700

> Let's be supportive of Ubuntu maintainers actually working on
> upstream resolution for a change. The normal distro maintainer is
> "patch and ignore".

This has nothing to do with being supportive or not.

If the changes are wrong, many of these in fact were, and they were
not even tested on top of it, I cannot be happy at all about that.

And that goes for anyone submitting patches here.
