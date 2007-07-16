Return-Path: <linux-kernel-owner+w=401wt.eu-S1764478AbXGPVoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764478AbXGPVoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbXGPVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:44:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717AbXGPVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:44:07 -0400
Date: Mon, 16 Jul 2007 14:42:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: jeremy@goop.org, ak@suse.de, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, lenb@kernel.org, randy.dunlap@oracle.com,
       viro@zeniv.linux.org.uk, arnd@arndb.de
Subject: Re: [patch 6/7] Add common orderly_poweroff()
Message-Id: <20070716144245.38b90875.akpm@linux-foundation.org>
In-Reply-To: <20070716.143106.35661927.davem@davemloft.net>
References: <20070510235708.155502000@goop.org>
	<20070511000028.446470000@goop.org>
	<20070716125223.249a6914.akpm@linux-foundation.org>
	<20070716.143106.35661927.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 14:31:06 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Mon, 16 Jul 2007 12:52:23 -0700
> 
> > Dave, those changes hit mainline without ever having appeared in the
> > sparc-2.6.git tree, afaict.
> 
> It's been in there for more than a week.

Nope, I pulled all the git trees on July 1,2,5,6,8,10 and 13 (at least) but
git-sparc64.patch did not change between July 1 and July 16.

At all times I've been pulling from
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git. 
Perhaps that was the wrong branch?  
