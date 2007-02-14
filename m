Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbXBNKb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbXBNKb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXBNKb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:31:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36462 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXBNKb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:31:28 -0500
Subject: Re: [patch 05/11] syslets: core code
From: Arjan van de Ven <arjan@infradead.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070214100955.GA23702@2ka.mipt.ru>
References: <20060529212109.GA2058@elte.hu> <20070213142035.GF638@elte.hu>
	 <p73bqjxhcnl.fsf@bingen.suse.de> <20070213222443.GH22104@elte.hu>
	 <20070213223017.GJ29492@one.firstfloor.org>
	 <20070213224131.GK22104@elte.hu> <20070214091348.GB4665@2ka.mipt.ru>
	 <20070214094629.GA6801@elte.hu>  <20070214100955.GA23702@2ka.mipt.ru>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 14 Feb 2007 11:30:55 +0100
Message-Id: <1171449055.12771.254.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (at least on Debian
> and Mandrake there is no locked memory limit by default).

that sounds like 2 very large bugtraq-worthy bugs in these distros.. so
bad a bug that I almost find it hard to believe...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

