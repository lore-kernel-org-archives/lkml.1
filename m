Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXCCMH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXCCMH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 07:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965257AbXCCMH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 07:07:56 -0500
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:39727 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbXCCMHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 07:07:55 -0500
From: Junio C Hamano <junkio@cox.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@qumranet.com>, Jens Axboe <jens.axboe@oracle.com>,
       Daniel Walker <dwalker@mvista.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pavel@smtp.osdl.org, linux-pm@lists.osdl.org,
       List <linux-kernel@vger.kernel.org>, Len@smtp.osdl.org,
       Adrian Bunk <bunk@stusta.de>, Machek <pavel@ucw.cz>,
       Linux@smtp.osdl.org, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] KVM: T60 resume fix
References: <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk>
	<20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu>
	<20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu>
	<Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org>
	<20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu>
	<20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu>
	<45E93012.4000100@qumranet.com>
	<20070303035742.72eed3df.akpm@linux-foundation.org>
Date: Sat, 03 Mar 2007 04:07:53 -0800
In-Reply-To: <20070303035742.72eed3df.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 3 Mar 2007 03:57:42 -0800")
Message-ID: <7vejo6cyxy.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could you un-CC: git@vger.kernel.org from this thread, please?

