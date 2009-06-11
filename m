Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZFKQ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZFKQ4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZFKQ41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:56:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:57454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZFKQ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:56:26 -0400
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090611165226.GV8633@ZenIV.linux.org.uk>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <20090611165226.GV8633@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 18:56:18 +0200
Message-Id: <1244739378.6691.540.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 17:52 +0100, Al Viro wrote:

> Do you consider "put into tools/" as permission to change interface at will?
> More to the point, do the authors of that stuff consider it as such?

No, once a kernel with this syscall gets released we most certainly
intend to maintain its ABI.

