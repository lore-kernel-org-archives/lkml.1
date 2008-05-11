Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYEKWPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYEKWPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbYEKWOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:14:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34820
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756953AbYEKWOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:14:53 -0400
Date: Sun, 11 May 2008 15:14:47 -0700 (PDT)
Message-Id: <20080511.151447.82557271.davem@davemloft.net>
To: sam@ravnborg.org
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn/capi: return proper errnos on module init
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080511212117.GB1641@uranus.ravnborg.org>
References: <20080511210707.GA25600@pingi.kke.suse.de>
	<20080511212117.GB1641@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 11 May 2008 23:21:17 +0200

> Lately David Miller has started to include isdn patches
> in his netdev tree. So I think you should pass then on to David
> and not Andrew.
> David or Andrew will correct me if I'm wrong...

Yes, I try to pick them up.
