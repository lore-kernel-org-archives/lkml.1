Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbXBPPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbXBPPzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932421AbXBPPzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:55:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48801 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403AbXBPPzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:55:36 -0500
Date: Fri, 16 Feb 2007 07:54:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <20070216085706.GA22868@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
 <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
 <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
 <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
 <20070216085706.GA22868@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Feb 2007, Evgeniy Polyakov wrote:
> 
> Interfaces can be created and destroyed - they do not affect overall
> system design in anyway (well, if they do, something is broken).

I'm sorry, but you've obviously never maintained any piece of software 
that actually has users.

As long as you think that interfaces can change, this discussion is 
pointless. 

So go away, ponder things.

		Linus
