Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZFOHCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZFOHCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZFOHCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:02:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:37420 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZFOHCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:02:03 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1245031736.19217.15.camel@pasglop>
References: <1245031736.19217.15.camel@pasglop>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 17:01:51 +1000
Message-Id: <1245049311.19217.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 12:09 +1000, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> Here's the first half of the powerpc merge for 2.6.31. I'll have the
> rest in a couple of days, just dealing with some of my own backlog here
> plus some collisions.

 .../...

>   git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Use "merge" not "next" please. I added some more stuff in "next" after
that request that need to sit a bit before you pull it, I didn't notice
that git request-pull picked up the wrong branch :-)

Cheers,
Ben.


