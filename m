Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbYDCIRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbYDCIRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbYDCIRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:17:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47472 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYDCIRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:17:22 -0400
Date: Thu, 03 Apr 2008 17:17:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [rfc] SLQB: YASA
Cc: kosaki.motohiro@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20080403075725.GA7514@wotan.suse.de>
References: <84144f020804030045p44456894lfc006dcdeab6f67c@mail.gmail.com> <20080403075725.GA7514@wotan.suse.de>
Message-Id: <20080403171626.0283.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

> > Why is this not a patch set against SLUB?
> 
> It's a completely different design of the core allocator algorithms
> really.
> 
> It probably looks quite similar because I started with slub.c, but
> really is just the peripheral supporting code and structure. I'm never
> intending to try to go through the pain of incrementally changing SLUB
> into SLQB. If SLQB is found to be a good idea, then it could maybe get
> merged.

Do you have performance mesurement result?
I hope see it if possible.

Thanks! :)


