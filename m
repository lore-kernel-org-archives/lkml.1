Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbZCZW7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbZCZW7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZCZW7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:59:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbZCZW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:59:21 -0400
Date: Thu, 26 Mar 2009 15:56:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>
cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT]: Networking for 2.6.30
In-Reply-To: <20090326.152515.43533230.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0903261555290.3032@localhost.localdomain>
References: <20090326.020714.36421849.davem@davemloft.net> <20090326.152515.43533230.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, David Miller wrote:
> 
> Just FYI, I've just pushed a merge of the changes you pulled in today
> in order to resolve the one merge conflict that arose.

Well, I merged infiniband, and that caused more conflicts. I fixed them 
up, but people need to double-check my fixes.

		Linus
