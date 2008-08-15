Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYHOJSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYHOJSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYHOJSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:18:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50967 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920AbYHOJSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:18:02 -0400
Date: Fri, 15 Aug 2008 10:00:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Blackfin serial driver bug fixing
Message-ID: <20080815100052.0e03d11d@lxorguk.ukuu.org.uk>
In-Reply-To: <1218788049-7632-1-git-send-email-cooloney@kernel.org>
References: <1218788049-7632-1-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 16:14:07 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> 
> Hi Alan,
> 
> Here is 2 critical bug fixing patch for Blackfin serial driver.
> And as you acked the previous 8 Blackfin serial driver patches, need I
> push them to blackfin-2.6 git tree and ask Linus to pull from that or
> they were queued in your serial tree?

The existing ones were queued for 2.6.28 as I assumed that was what your
email meant you want to do. If you have critical fixes at this point in
the -rc series I would send them direct to Linus
