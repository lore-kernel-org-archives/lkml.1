Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbYCCSxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbYCCSxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYCCSxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:53:00 -0500
Received: from relay2.sgi.com ([192.48.171.30]:36184 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752257AbYCCSxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:53:00 -0500
Date: Mon, 3 Mar 2008 12:52:53 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080303125253.5d2d580c.pj@sgi.com>
In-Reply-To: <6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229190223.GA17820@elte.hu>
	<47C87084.3090208@qualcomm.com>
	<1204318980.6243.133.camel@lappy>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> It ... would allow memory and CPU assignments to be controlled
> independently.

Could you motivate this suggestion -- who needs it, or why
would is it needed?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
