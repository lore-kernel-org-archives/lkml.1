Return-Path: <linux-kernel-owner+w=401wt.eu-S934147AbXGMTxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbXGMTxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbXGMTx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:53:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757056AbXGMTx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:53:26 -0400
Date: Fri, 13 Jul 2007 12:53:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 904f7a3f042b5c6aa9e53ce83f2c9de5e33170ff
In-Reply-To: <20070713193138.GA31781@redhat.com>
Message-ID: <alpine.LFD.0.999.0707131252580.20061@woody.linux-foundation.org>
References: <4697B7DB.3030006@zytor.com> <20070713182739.GE28567@redhat.com>
 <20070713193138.GA31781@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Jul 2007, Dave Jones wrote:
> 
> Can we be a bit less trigger happy about reverting stuff ?
> Linus, how do you want to proceed, cpufreq.git has that fixed, but
> will you now have to revert the revert, or will I have to do something?

Point mw to your fixed repo, I'll fix it up,

		Linus
