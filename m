Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbXH0Q3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbXH0Q3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbXH0Q2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:28:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878AbXH0Q2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:28:53 -0400
Date: Mon, 27 Aug 2007 09:28:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reset current->pdeath_signal on SUID binary execution
In-Reply-To: <46D2EEA2.6070501@gmx.net>
Message-ID: <alpine.LFD.0.999.0708270927380.25853@woody.linux-foundation.org>
References: <1187380078.6698.448.camel@violet> <1187857271.15402.20.camel@violet>
 <46D2EEA2.6070501@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Aug 2007, Michael Kerrisk wrote:
> 
> But it's not clear to me in which 2.4.x and 2.6.x versions the change 
> occurred (it isn't in 2.6.23-rc3 -- is it scheduled for 2.6.23-rc4?).  

It's in current -git (commit d2d56c5f51028cb9f3d800882eb6f4cbd3f9099f), so 
yes, it will be in -rc4 (which should happen today).

		Linus
