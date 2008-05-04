Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYEDEDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYEDEDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 00:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYEDEDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 00:03:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41385
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbYEDEDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 00:03:36 -0400
Date: Sat, 03 May 2008 21:03:36 -0700 (PDT)
Message-Id: <20080503.210336.81094599.davem@davemloft.net>
To: marcin.slusarz@gmail.com
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] xfrm: convert empty xfrm_audit_* macros to functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503224130.GA6120@joi>
References: <20080503224130.GA6120@joi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>
Date: Sun, 4 May 2008 00:42:46 +0200

> it removes these warnings when CONFIG_AUDITSYSCALL is unset:

I had been noticing these in my builds and had meant to get to
fixing it, but you beat me to it :)

Patch applied, thanks!
