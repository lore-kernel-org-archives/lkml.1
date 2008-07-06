Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYGFW4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYGFW4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 18:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbYGFW4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 18:56:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56623 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbYGFW4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 18:56:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Date: Mon, 7 Jul 2008 00:57:50 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <200807062356.47908.rjw@sisk.pl> <487142BA.1080508@keyaccess.nl>
In-Reply-To: <487142BA.1080508@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807070057.51663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Rene Herman wrote:
> On 06-07-08 23:56, Rafael J. Wysocki wrote:
> 
> > BTW, the automated emails I'm sending are to let the reporters know
> > that I'm interested in the current status of the bug.  They are free
> > not to reply to them, but in that case I assume they don't really
> > care whether or not I'm tracking the bugs they reported.
> 
> I did/do wonder by the way when I get them if I should be replying if 
> the status is unchanged from my viewpoint...
> 
> I believe your automated emails say something like "please verify if 
> this problem is still relevant" but don't spell out what do after you
> verified that it is. It's sort of natural to take that as "I need to 
> reply telling people it's fixed if it is but can remain silent if 
> nothing changed".

The exact wording is

"The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed."

> Being more explicit about liking a reporter to report "yes, nothing 
> changed" would probably be good if that IS what's wanted.

Well, I can change it to

"Please verify if it still should be listed and let me know."

if that's better.

Thanks,
Rafael
