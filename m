Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZEOPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZEOPK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZEOPKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:10:51 -0400
Received: from vena.lwn.net ([206.168.112.25]:43585 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbZEOPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:10:50 -0400
Date: Fri, 15 May 2009 09:10:46 -0600
From: Jake Edge <jake@lwn.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alan@hera.kernel.org,
       security@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, Linux@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       mingo@redhat.com, Arjan@hera.kernel.org, Matt Mackall <mpm@selenic.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Message-ID: <20090515091046.6dc9daaf@chukar>
In-Reply-To: <20090515134717.GA16389@elte.hu>
References: <20090505063156.GA24504@elte.hu>
	<m14ow0ynjm.fsf@fess.ebiederm.org>
	<20090505195246.GC21973@elte.hu>
	<20090505202219.GL31071@waste.org>
	<20090506103034.GA25203@elte.hu>
	<20090506162543.GT31071@waste.org>
	<alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
	<20090506200954.GA21484@elte.hu>
	<20090514164737.6eaab4f0@chukar>
	<alpine.LFD.2.01.0905141553010.3343@localhost.localdomain>
	<20090515134717.GA16389@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 15:47:17 +0200 Ingo Molnar wrote:

> Jake, mind bouncing the 
> commit notification to stable@kernel.org?

Not at all, done!

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
