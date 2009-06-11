Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZFKRIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZFKRIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZFKRIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:08:04 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36845 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbZFKRID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:08:03 -0400
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Marcel Holtmann <marcel@holtmann.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <2c0942db0906111005g5e9cd1c7te603bcdb8c6cc921@mail.gmail.com>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <20090611165226.GV8633@ZenIV.linux.org.uk>
	 <1244739378.6691.540.camel@laptop>  <20090611170015.GA3651@infradead.org>
	 <2c0942db0906111005g5e9cd1c7te603bcdb8c6cc921@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 19:08:01 +0200
Message-Id: <1244740081.27363.41.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ray,

> >> No, once a kernel with this syscall gets released we most certainly
> >> intend to maintain its ABI.
> >
> > So what point is there in keeping it in-tree except making life hell for
> > packagers?
> 
> Packagers are quite used to taking a single source tree and building
> multiple packages out of it. This isn't rocket science. It's the
> multiple separate trees that need to be released in lock-step that are
> headaches.

with the kernel as source package it is a headache and really painful.
All distros struggle already enough with kernel updates.

Regards

Marcel


