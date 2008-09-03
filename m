Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYICXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYICXYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYICXYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:24:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbYICXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:24:19 -0400
Date: Wed, 3 Sep 2008 16:24:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <alpine.LFD.1.10.0809031615450.3515@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809031621160.3515@nehalem.linux-foundation.org>
References: <20080903.161341.239039051.davem@davemloft.net> <alpine.LFD.1.10.0809031615450.3515@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, Linus Torvalds wrote:
> 
> What's so hard to understand about this?

Here's a simple rule of thumb:
 - if it's not on the regression list
 - if it's not a reported security hole
 - if it's not on the reported oopses list
then why are people sending it to me?

IOW, if it's just another random improvement, and you send it to me 
outside of the merge window, then what is the point of the merge window? 

		Linus
