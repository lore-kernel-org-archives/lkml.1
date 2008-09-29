Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbYI2RT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbYI2RT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYI2RTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:19:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49754 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYI2RTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:19:48 -0400
Message-ID: <48E10E4F.3000201@redhat.com>
Date: Mon, 29 Sep 2008 13:20:15 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jason Czerak <jason@czerak.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: mounted file system bottleneck
References: <325d52860809290641haddf616xfe9c98912352ba22@mail.gmail.com> <325d52860809290645p7526b318h7ff9b7e76570f65f@mail.gmail.com>
In-Reply-To: <325d52860809290645p7526b318h7ff9b7e76570f65f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Czerak wrote:
> I believe I found some sort of bottleneck with mounted networked file
> systems over 10Gig Ethernet.  I've posted a question to linux-net with
> zero response since Friday.

You're posting a support question to a developer list.  This is frowned upon. 
You might get more attention here if you conduct a more scientific test and 
report it in a more scientific fashion.

> http://www.uwsg.indiana.edu/hypermail/linux/net/0809.3/0013.html

This is also frowned upon.  Please send your data directly to the list, unless 
it is absolutely enormous.

> Could a few of you folks here take a look at this and tell me what you
> think is the issue?

Offhand, I'd guess atime updates.  Unless you're seeing this on a new upstream 
kernel, you should contact your vendor for support.  Or NetApp.

-- Chris
