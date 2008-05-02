Return-Path: <linux-kernel-owner+w=401wt.eu-S934768AbYEBMS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768AbYEBMS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763509AbYEBMSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:18:18 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39154 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbYEBMSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:18:18 -0400
Message-ID: <481B0646.7090107@s5r6.in-berlin.de>
Date: Fri, 02 May 2008 14:17:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org> <200805012359.41544.rjw@sisk.pl>
In-Reply-To: <200805012359.41544.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> A general rule that the trees people want you to pull during a merge window
> should be tested in linux-next before, with no additional last minute changes,
> may help.
> 
> For this to work, though, the people will have to know in advance when the
> merge window will start.  Which may be helpful anyway.

If I only release into my tree's for-next branch what I would release
into my tree's for-linus if I was to send a merge request to Linus right
in this moment, then I won't need advance notice of a merge window.

IOW, treat -next everyday as if the merge window was open right now.

I'm sure it is not that easy for the larger subsystems or the
infrastructure trees.  However, Linus' late -rc announcements are plenty
of advance notice, at least for a merge period as long as two weeks.
-- 
Stefan Richter
-=====-==--- -=-= ---=-
http://arcgraph.de/sr/
