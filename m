Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbYFPHks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbYFPHks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYFPHkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:40:37 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:44371 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752519AbYFPHkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:40:36 -0400
Message-ID: <485618F1.8020801@davidnewall.com>
Date: Mon, 16 Jun 2008 17:10:33 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Chris Fowler <cfowler@outpostsentinel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: Feedback on TCP: Make TCP_RTO_MAX a variable
References: <4855823F.40208@davidnewall.com> <4855B5A1.7060704@outpostsentinel.com>
In-Reply-To: <4855B5A1.7060704@outpostsentinel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Fowler wrote:
> My only question would be that if you did not have this feature how
> would you have solved your problem?


I have no idea.  An option would be to use private managed links, but
that would cost about 100 times as much, and I would not be able to
administer the machines via the internet.

With programs that scan and probe the internet, widely available for
every script-kiddies entertainment, I believe this is, as I said, a
standard characteristic of the internet, and I must live with it.  Had
this been an actual DOS attack on my client, rather than the normal,
random attention from said script-kiddies, reducing TCP_RTO_MAX would
not have helped.
