Return-Path: <linux-kernel-owner+w=401wt.eu-S1750714AbXBMPJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbXBMPJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbXBMPJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:09:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43258 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXBMPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:09:41 -0500
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
	call support
From: Arjan van de Ven <arjan@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070213145848.GS18311@kvack.org>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
	 <20070213150019.4b4d4827@localhost.localdomain>
	 <20070213145848.GS18311@kvack.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 16:09:12 +0100
Message-Id: <1171379353.12771.120.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 09:58 -0500, Benjamin LaHaise wrote:
> On Tue, Feb 13, 2007 at 03:00:19PM +0000, Alan wrote:
> > > Open issues:
> > 
> > Let me add some more
> 
> Also: FPU state (especially important with the FPU and SSE memory copy 
> variants)

are these preserved over explicit system calls? 
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

