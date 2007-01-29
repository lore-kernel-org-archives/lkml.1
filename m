Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbXA2NjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbXA2NjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbXA2NjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:39:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:60168 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbXA2NjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:39:21 -0500
From: Andi Kleen <ak@suse.de>
To: David Rientjes <rientjes@cs.washington.edu>
Subject: Re: [patch -mm 3/5] x86_64: fixed-size remaining fake nodes
Date: Mon, 29 Jan 2007 14:36:59 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@osdl.org>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64N.0701251332280.13206@attu4.cs.washington.edu> <Pine.LNX.4.64N.0701251333470.13206@attu4.cs.washington.edu> <Pine.LNX.4.64N.0701251334280.13206@attu4.cs.washington.edu>
In-Reply-To: <Pine.LNX.4.64N.0701251334280.13206@attu4.cs.washington.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701291436.59930.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 January 2007 22:37, David Rientjes wrote:
> Any leftover memory is allocated
> to a final node unless the command-line ends with a comma.

That sounds like syntactical vinegar and a nasty trap. Remember 
that venus probe that got lost because of a wrong comma.
Can you find some nicer syntax for that please? 

Also it's pretty complex. Are there use cases for all of this? 

-Andi
