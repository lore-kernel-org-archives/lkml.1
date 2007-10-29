Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXJ2VqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXJ2VqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXJ2Vpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:45:53 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55432 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbXJ2Vpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:45:52 -0400
Date: Mon, 29 Oct 2007 17:45:52 -0400
To: Wijnand Rietman <wijnand.rietman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_IDEDMA_AUTO & 2.4.32 & hdparm -d1
Message-ID: <20071029214551.GB27643@csclub.uwaterloo.ca>
References: <b3790d380710290605g5d1770fao675418f062f111b9@mail.gmail.com> <20071029194241.GA27646@csclub.uwaterloo.ca> <b3790d380710291352k83e04ebl331f8bb784ba218c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3790d380710291352k83e04ebl331f8bb784ba218c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 09:52:35PM +0100, Wijnand Rietman wrote:
> Thanks Lens for the suggestion!
> 
> Unfortunately this option doesn't work either. When I pass the "nodma"
> paramater to the kernel, it boots with DMA disabled (like it should),
> but doesn't allow DMA to be enabled anymore with hdparm.

Hmm, I was pretty sure I had the ability to turn it on after the fact
before.  Perhaps I was wrong.  That would be silly.  There has to be
some option to do what you want.

--
Len Sorensen
