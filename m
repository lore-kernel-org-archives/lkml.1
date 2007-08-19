Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbXHSULG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbXHSULG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 16:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbXHSUKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 16:10:53 -0400
Received: from khc.piap.pl ([195.187.100.11]:55363 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187AbXHSUKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 16:10:33 -0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Joe Perches <joe@perches.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tracking MAINTAINERS versus tracking SUBSYSTEMS
References: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain>
	<1187483578.4200.51.camel@localhost>
	<Pine.LNX.4.64.0708190818280.7224@localhost.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 19 Aug 2007 22:10:27 +0200
In-Reply-To: <Pine.LNX.4.64.0708190818280.7224@localhost.localdomain> (Robert P. J. Day's message of "Sun, 19 Aug 2007 08:22:18 -0400 (EDT)")
Message-ID: <m3y7g7gua4.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@mindspring.com> writes:

> i'm confused -- i thought that was sort of the whole purpose of this
> exercise, to match parts of the kernel source tree against the
> maintainer for those parts, and to do that via the defined
> "subsystem" which is currently used in MAINTAINERS.
>
> you can, of course, banish the concept of a subsystem entirely and
> work purely from a file and directory perspective, but i think the
> notion of the kernel tree being composed of subsystems is a useful
> idea.  that's just my opinion, though.

Obviously the concept of subsystems is the right one, except that
the subsystems aren't that well defined (or they are but not
for average kernel user) - thus "file masks".
-- 
Krzysztof Halasa
