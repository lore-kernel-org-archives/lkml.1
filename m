Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0AOJRm (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147Ab0AOJRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:17:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46928 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab0AOJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:17:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 15 Jan 2010 10:17:08 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Changelog quality
To: David Miller <davem@davemloft.net>
cc: adi@hexapodia.org, julia@diku.dk, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk
In-Reply-To: <20100115.005445.263291449.davem@davemloft.net>
Message-ID: <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>
References: <4B5023A6.5070100@s5r6.in-berlin.de>
 <20100115.002424.100105244.davem@davemloft.net>
 <4B502C6B.7000802@s5r6.in-berlin.de>
 <20100115.005445.263291449.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jan, David Miller wrote:
> What button do I push in gitk when viewing a commit to find the
> script?
> 
> If I have to go out of the tool, that's the beginning down the long
> road of potential distractions.

[There is a button in gitk which launches coccinelle and feeds the
copy-an-paste buffer into it?]

So somebody scripted a test which finds a certain type of problem, ran
it on the tree, and submitted fixes.  Later on, somebody wants to re-run
the test to check whether this problem was reintroduced in new code.  So
you are arguing that this somebody should, among else, find one of the
parts required for the test in the kernel source repository's changelog
metadata when he is in the process to add that test to his toolkit.

I on the other hold the opinion that the changelog has one purpose, to
describe the code change.
-- 
Stefan Richter
-=====-==-=- ---= -====
http://arcgraph.de/sr/

