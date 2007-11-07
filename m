Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbXKGJ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbXKGJ3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXKGJ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:29:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45353
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756899AbXKGJ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:29:13 -0500
Date: Wed, 07 Nov 2007 01:29:13 -0800 (PST)
Message-Id: <20071107.012913.32554750.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] tty - fix tty network driver interactions with
 TCGET/TCSET calls
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071102160252.6660e482@the-village.bc.nu>
References: <20071102160252.6660e482@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 2 Nov 2007 16:02:52 +0000

> We conciously make a change here - we permit mode and speed setting to be
> done in things like SLIP mode. There isn't actually a technical reason to
> disallow this. It's usually a silly thing to do but we can do it and
> soemone might wish to do so.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Applied.
