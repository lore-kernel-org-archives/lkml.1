Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZCLXfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZCLXfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZCLXfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:35:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbZCLXfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:35:31 -0400
Date: Thu, 12 Mar 2009 16:33:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT-PULL] More squashfs fixes for 2.6.29 (try 2)
In-Reply-To: <E1LhbtX-0001hu-2A@dylan.lougher.demon.co.uk>
Message-ID: <alpine.LFD.2.00.0903121633130.32478@localhost.localdomain>
References: <E1LhbtX-0001hu-2A@dylan.lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Mar 2009, Phillip Lougher wrote:
> 
> This is a revised patch that fixes the bugged "fix oops when reading
> fsfuzzer corrupted filesystems patch".  I've replaced the original
> dumb check (and admitted it was dumb this time), changed the
> Z_NO_FLUSH flag to the more correct Z_SYNC_FLUSH and made the error
> messages more understandable to non-technical users.

Ok, this looks much more reasonable.

Pulled. Thanks,

		Linus
