Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbYBBNL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbYBBNL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYBBNLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:11:21 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33821 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYBBNLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:11:21 -0500
Message-ID: <47A46BF8.6030306@davidnewall.com>
Date: Sat, 02 Feb 2008 23:41:20 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.23.14
References: <479A83DE.8020002@davidnewall.com> <20080202074406.GA31516@1wt.eu>
In-Reply-To: <20080202074406.GA31516@1wt.eu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

Willy Tarreau wrote:
> Based on the above conditions, I'd like you to tell Greg and I if you
> consider it worth to merge this backport in 2.4 now. From my point of
> view, your work looks OK but I want your feedback as a user (and not
> as the backporter), then Greg's approval.

The data loss I experienced did go away with the back-port, but I think
that was because of the bigger buffers, rather than any true fix. Other
than the extra product ids, it won't really change anything. I'm hoping
the additional work I've done since then will correct the underlying
fault. (Wish I could get some feedback on it.) I'd be happy for you to
wait for that.
