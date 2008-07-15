Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYGOWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYGOWPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYGOWPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:15:37 -0400
Received: from vena.lwn.net ([206.168.112.25]:47216 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYGOWPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:15:36 -0400
Date: Tue, 15 Jul 2008 16:15:32 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] bkl-removal tree
Message-ID: <20080715161532.3fee41cb@bike.lwn.net>
In-Reply-To: <200807150929.25961.borntraeger@de.ibm.com>
References: <20080714154335.100afd6b@bike.lwn.net>
	<200807150929.25961.borntraeger@de.ibm.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 09:29:25 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Ok. Lets answer this question for anybody :-)
> I own this driver and I want to remove the BKL as soon as I am
> confident its ok. Should the followup patch be merged with Jonathans
> tree or should I sent it directly to Andrew or Linus?

I'll continue to maintain the bkl-removal tree, so you can certainly
send your patch meward and I'll herd it on upstream.  It's also OK to
send it up yourself or through a subsystem tree, of course.  I'm not
sure I'd bug Linus for detail stuff on this level...

jon
