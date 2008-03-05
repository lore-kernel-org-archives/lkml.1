Return-Path: <linux-kernel-owner+w=401wt.eu-S1761956AbYCERob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956AbYCERob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762562AbYCERoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:44:08 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58869 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760986AbYCERoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:44:07 -0500
Date: Wed, 5 Mar 2008 11:44:00 -0600
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080305114400.7f38ded6.pj@sgi.com>
In-Reply-To: <20080305124348.GB2365@elte.hu>
References: <1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<1204568316.8514.18.camel@twins>
	<20080304013534.4e51ae48.pj@sgi.com>
	<1204628762.6241.46.camel@lappy>
	<47CDA885.3000103@qualcomm.com>
	<20080304191159.a02be58b.pj@sgi.com>
	<1204706272.6241.79.camel@lappy>
	<20080305085019.GA24097@elte.hu>
	<20080305063518.69d03de1.pj@sgi.com>
	<20080305124348.GB2365@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> > i always thought that cpusets should boot up with some meaningful 
> > default set that people could play with.

Paul replied:
> They do ... you just have to mount cpusets to see it ;).

Ingo replied:
> the root cpuset is special as it is the root of the tree.

Yes ... true ... so?  I guess whatever you meant by "meaningful"
doesn't include the root cpuset.  Oh well <grin>.

To be a tad more serious, it wasn't (still isn't) clear to me
what you did mean here.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
