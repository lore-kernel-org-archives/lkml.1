Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbXDZIjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbXDZIjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933652AbXDZIjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:39:42 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:47504 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933647AbXDZIjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:39:42 -0400
Date: Thu, 26 Apr 2007 10:38:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <1177567481.5025.211.camel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.61.0704261037250.506@yvahk01.tjqt.qr>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 26 2007 16:04, Nigel Cunningham wrote:
>
>Hi again.
>
>So - trying to get back to the original discussion - what (if anything)
>do you see as the way ahead?
>
>The options I can think of are (starting with things I can do):
>
>1) [...]
>2) [...]
>3) [...]
>4) [...]
>5) [...]
>6) [...]
>7) [...]

Perhaps do it the EVMS way? Do as much in userspace as possible, and
trying having a simple kernel API at the same time.
Perhaps (3) would be it, but ask Redhat _first_ before quitting anything :)


Jan
-- 
