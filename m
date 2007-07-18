Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbXGRULI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbXGRULI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbXGRUKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:10:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbXGRUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:10:46 -0400
Date: Wed, 18 Jul 2007 22:10:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718201043.GF3898@one.firstfloor.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718194137.GG11166@waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I was waiting for someone to make that "point" ...

> 
> Every byte you can shave off the compressed kernel image is another
> byte you can use for userspace on your FLASH.

Now let's see if that 1MB 386 contains any flash at all. Guesses?  

-Andi
