Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbXHYGZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbXHYGZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 02:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXHYGZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 02:25:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43929
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755749AbXHYGZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 02:25:50 -0400
Date: Fri, 24 Aug 2007 23:25:49 -0700 (PDT)
Message-Id: <20070824.232549.122949008.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de,
       isdn4linux@listserv.isdn4linux.de,
       Michael.Hipp@student.uni-tuebingen.de
Subject: Re: [PATCH 17/30] isdn: Get rid of some pointless allocation casts
 in common and bsd comp.
From: David Miller <davem@davemloft.net>
In-Reply-To: <85cd9d8df6b94f6dbf4842a4b2aabe05737a3b46.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	<85cd9d8df6b94f6dbf4842a4b2aabe05737a3b46.1187912217.git.jesper.juhl@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:09:34 +0200

> vmalloc() returns a void pointer - no need to cast the return value.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Applied, thanks.
