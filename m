Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXBZS5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXBZS5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030456AbXBZS5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:57:10 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:55647 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030455AbXBZS5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:57:09 -0500
Message-ID: <45E32D61.7060403@nortel.com>
Date: Mon, 26 Feb 2007 12:56:33 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226131133.GA11777@elte.hu> <20070226173701.GD22454@2ka.mipt.ru> <1172513950.3280.388.camel@laptopd505.fenrus.org> <20070226183856.GF22454@2ka.mipt.ru>
In-Reply-To: <20070226183856.GF22454@2ka.mipt.ru>
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2007 18:56:39.0385 (UTC) FILETIME=[D8D24C90:01C759D7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:

> I never ever tried to say _everything_ must be driven by events.
> IO must be driven, it is a must IMO.

Do you disagree with Linus' post about the difficulty of treating 
open(), fstat(), page faults, etc. as events?  Or do you not consider 
them to be IO?

Chris
