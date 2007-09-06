Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbXIFOu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbXIFOu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 10:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXIFOuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:50:14 -0400
Received: from 1wt.eu ([62.212.114.60]:2410 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXIFOuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:50:13 -0400
Date: Thu, 6 Sep 2007 16:50:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: Richard Kojedzinszky <krichy@tvnetwork.hu>
Cc: Axel Reinhold <axel@freakout.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.4.35.1 and panic at boot with arch=c3 and gcc-4.x
Message-ID: <20070906145003.GA17768@1wt.eu>
References: <20070905220027.GB11602@1wt.eu> <Pine.LNX.4.64.0709061636500.11037@krichy.tvnetwork.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709061636500.11037@krichy.tvnetwork.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:37:20PM +0200, Richard Kojedzinszky wrote:
> Dear Willy,
> 
> I can confirm that this fixes the problem, the kernel indeed boots on such 
> a board.

Thanks Richard,

I'm queuing it for 2.4.35.2.

Best regards,
Willy

