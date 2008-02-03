Return-Path: <linux-kernel-owner+w=401wt.eu-S935010AbYBCArE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010AbYBCArE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYBCAqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:46:53 -0500
Received: from simmts8-srv.bellnexxia.net ([206.47.199.166]:38866 "EHLO
	simmts8-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbYBCAqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:46:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAB6dpEecIplu/2dsb2JhbAAIrE8
Message-ID: <47A50EF8.6020507@gmail.com>
Date: Sat, 02 Feb 2008 20:46:48 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Automated Kernel Testing
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo & Andrew,

Since you both seem to be quite interested in the number of kernel
testers and the reporting of bugs, I figured I would bounce this idea
off of you...

As a part-time kernel tester, I find it interesting to see that Ingo has
tools that are able to automatically configure/build/boot/test kernels,
and it has given me the following ideas:

- For people like me, it would be great if there were a downloadable
collection of tools for performing similar testing on my box here
whenever I'm not using it.
- The tools could build a kernel, boot it, run some standard tests, and
report any problems automatically.
- The kernel oops web site and auto-submit tool seems like it would be a
very good companion to the testing tools (if you don't already have them
integrated).
- In the future, I would expect that a SETI@Home-style testing package
could be integrated into distribution repositories so that users could
do automatic testing (build testing for people scared about data loss,
and boot testing as well for those not worried).

I would be happy to help out with the work in developing this set of
tools (as far as my limited skills allow), but I have a feeling that you
already have most of it in some form.  I think the final piece is just
the integration and marketing so that the barrier to kernel testing gets
lowered considerably.

Does this seem like a reasonable idea, or is it something that you
already had in mind (that it just took me longer to see)?

-- 
Kevin Winchester
