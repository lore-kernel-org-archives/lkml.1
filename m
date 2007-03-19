Return-Path: <linux-kernel-owner+w=401wt.eu-S1751033AbXCSOXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbXCSOXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 10:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbXCSOXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 10:23:16 -0400
Received: from colin.muc.de ([193.149.48.1]:2870 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbXCSOXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 10:23:15 -0400
Date: 19 Mar 2007 15:23:13 +0100
Date: Mon, 19 Mar 2007 15:23:13 +0100
From: Andi Kleen <ak@muc.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH take3 00/20] Make common x86 arch area for i386 and x86_64 - Take 3
Message-ID: <20070319142313.GA44351@muc.de>
References: <20070315051337.488091591@goodmis.org> <20070316102933.GB4185@elte.hu> <45FDE202.80807@redhat.com> <20070319121752.GC2986@holomorphy.com> <45FE8BD9.9010009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FE8BD9.9010009@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> and gain nothing anyway.

That's my gripe about the common files directory too.

-Andi
