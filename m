Return-Path: <linux-kernel-owner+w=401wt.eu-S1750811AbXBMQYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750811AbXBMQYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbXBMQYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:24:22 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:55903 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXBMQYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:24:21 -0500
Date: Tue, 13 Feb 2007 17:24:19 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213162419.GA9999@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Benjamin LaHaise <bcrl@kvack.org>, Alan <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@zip.com.au>, Ulrich Drepper <drepper@redhat.com>,
	Zach Brown <zach.brown@oracle.com>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	Davide Libenzi <davidel@xmailserver.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213145848.GS18311@kvack.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 09:58:48AM -0500, Benjamin LaHaise wrote:

> not present is mandatory).  I have looked into exactly this approach, and 
> it's only cheaper if the code is incomplete.  Linux's native threads are 
> pretty damned good.

Cheaper in time or in memory? Iow, would you be able to queue up as many
threads as syslets?

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
