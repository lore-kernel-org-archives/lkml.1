Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZKRW7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZKRW7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZKRW7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:59:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbZKRW7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:59:33 -0500
Date: Wed, 18 Nov 2009 14:59:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <20091118.072506.229926265.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0911181455260.2793@localhost.localdomain>
References: <20091118.072506.229926265.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Nov 2009, David Miller wrote:
> 
> The following changes since commit 7c9abfb884b8737f0afdc8a88bcea77526f0da87:
>   Linus Torvalds (1):
>         Merge branch 'kvm-updates/2.6.32' of git://git.kernel.org/pub/scm/virt/kvm/kvm
> 
> are available in the git repository at:

Nope, they are not.

I'm not seeing half of it, including these first ones listed (among many 
others):

> Ajit Khaparde (2):
>       be2net: fix to set proper flow control on resume
>       be2net: Bug fix to send config commands to hardware after netdev_register

because I already pulled half of it over a week ago.. You seem to not have 
noticed, possibly because of some confusion?

Anyway, I do seem to get a proper subset, _and_ the stuff I don't get seem 
to be old stuff I already got earlier, so I think everything is fine. But 
you should double-check, because my diffstat/shortlog doesn't match yours 
due to you apparently having included data from previous pull requests..

			Linus
