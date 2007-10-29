Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbXJ2Sz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbXJ2Sz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbXJ2Szs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:55:48 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41319 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbXJ2Szr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:55:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kirill Korotaev <dev@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
References: <m1640t3has.fsf@ebiederm.dsl.xmission.com>
	<alpine.LFD.0.999.0710261053030.30120@woody.linux-foundation.org>
	<m1y7dpzn1s.fsf_-_@ebiederm.dsl.xmission.com>
	<472590FC.8070502@openvz.org>
Date: Mon, 29 Oct 2007 12:54:46 -0600
In-Reply-To: <472590FC.8070502@openvz.org> (Kirill Korotaev's message of "Mon,
	29 Oct 2007 10:51:24 +0300")
Message-ID: <m11wbdpx8p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev <dev@openvz.org> writes:

> Can you please send namespace related patches to containers@ ML first
> before sending them to Linus/Andrew?

If you are so anxious to review my patches can you please review them?
I'd love to see an acked-by or an actual bug found.

I only did what I always do when I am focusing on fixing a bug
in the stable kernel.  I fix the bug if I can with a simple obviously
correct patch and send that patch off to the maintainer.  Copying
other people that I know of who have a chance of reviewing the
patch.

Eric
