Return-Path: <linux-kernel-owner+w=401wt.eu-S1763844AbYFTVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763844AbYFTVlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYFTVla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:41:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33667
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753675AbYFTVl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:41:29 -0400
Date: Fri, 20 Jun 2008 14:41:28 -0700 (PDT)
Message-Id: <20080620.144128.32005196.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806201717190.14221@engineering.redhat.com>
References: <Pine.LNX.4.64.0806201624280.3668@engineering.redhat.com>
	<20080620.133721.95818057.davem@davemloft.net>
	<Pine.LNX.4.64.0806201717190.14221@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 20 Jun 2008 17:26:35 -0400 (EDT)

> it looks very scary.

I agree, it looks scary to me too.

Next week I'll make one of my primary projects the implementation of
IRQ stacks for sparc64.
