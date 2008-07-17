Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbYGQVbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbYGQVbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933210AbYGQVbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:31:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50733
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933193AbYGQVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:31:31 -0400
Date: Thu, 17 Jul 2008 14:31:31 -0700 (PDT)
Message-Id: <20080717.143131.06782831.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jeff@garzik.org, torvalds@linux-foundation.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080715134246.7bee32b1@the-village.bc.nu>
References: <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
	<487C500F.8000109@garzik.org>
	<20080715134246.7bee32b1@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 15 Jul 2008 13:42:46 +0100

> > * the legal subtext of these changes was not mentioned at all
> 
> The only legal subtext has been some mad fantasy proposed by Dave Miller
> that David Woodhouse current employer and previous one were both in some
> conspiracy to push firmware elsewhere. It would be very helpful if you
> stuck to the real world.

That was wrong, but there have been other legal subtexts.

request_firmware() itself, although partially done for technical reasons,
had some very real legal impetus.

Linus has even said that in this thread.
