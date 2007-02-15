Return-Path: <linux-kernel-owner+w=401wt.eu-S1030419AbXBOSGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419AbXBOSGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030418AbXBOSGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:06:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030417AbXBOSGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:06:35 -0500
Date: Thu, 15 Feb 2007 09:59:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/14] Syslets, generic asynchronous system call support,
 v2
In-Reply-To: <20070215165151.GA4285@elte.hu>
Message-ID: <Pine.LNX.4.64.0702150959060.20368@woody.linux-foundation.org>
References: <20070215165151.GA4285@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Ingo Molnar wrote:
> 
> this is the v2 release of the syslet subsystem. This is an interim 
> release, not all known and pending items are fixed/changed yet - the 
> tree is still work in progress:

I'm still not a huge fan of the user space interface, but at least the 
core code looks quite clean. No objections on that front.

		Linus
