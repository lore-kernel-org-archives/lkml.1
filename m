Return-Path: <linux-kernel-owner+w=401wt.eu-S1750786AbXBNRQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750786AbXBNRQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXBNRQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:16:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35859 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXBNRQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:16:09 -0500
Date: Wed, 14 Feb 2007 09:14:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
In-Reply-To: <20070214123755.GC23857@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0702140913560.3604@woody.linux-foundation.org>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
 <20070214123755.GC23857@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Feb 2007, Pavel Machek wrote:
> 
> Ouch, yet another interpretter in kernel :-(. Can we reuse acpi or
> something?

Hah. You make the joke! I get it!

Mwahahahaa! 

		Linus
