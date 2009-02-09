Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZBIA7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZBIA7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZBIA7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:59:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55569
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbZBIA7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:59:32 -0500
Date: Sun, 08 Feb 2009 16:59:25 -0800 (PST)
Message-Id: <20090208.165925.240846008.davem@davemloft.net>
To: dilinger@queued.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com
Subject: Re: [PATCH 10/15] sunxvr500: fix cmap memory leaks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090207121540.0e618d0f@ephemeral>
References: <20090207121540.0e618d0f@ephemeral>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>
Date: Sat, 7 Feb 2009 12:15:40 -0500

[ Fixed typo in adaplas's email address ]

>  - fix cmap leak in removal path
>  - fix cmap leak when register_framebuffer fails
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

I assume the fbdev folks will pick this up or should I take
it in my sparc tree?

Thanks.
