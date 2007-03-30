Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXC3KlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXC3KlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 06:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965047AbXC3KlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 06:41:15 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:54488 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965034AbXC3KlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 06:41:14 -0400
X-Greylist: delayed 1737 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 06:41:14 EDT
Subject: Kernel LZO compression + jffs2 and crypto usage
From: Richard Purdie <richard@openedhand.com>
To: David Woodhouse <dwmw2@infradead.org>, herbert@gondor.apana.org.au
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       akpm <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 11:11:58 +0100
Message-Id: <1175249518.5822.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've put the LZO patch series I sent a few weeks ago in a git tree:

http://git.o-hand.com/?p=linux-rpurdie;a=shortlog;h=linux-rpurdie-lzo

(git://git.o-hand.com/linux-rpurdie linux-rpurdie-lzo)

I'm not sure of the best way to merge this since it touches two
subsystems. David, do you want to pull the initial patch and jffs2 parts
and then the crpyto patch can follow through the crypto tree? I'm hoping
this can make 2.6.22. 

Let me know if there is anything further I can do to help.

Cheers,

Richard

