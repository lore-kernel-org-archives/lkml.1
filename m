Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYC1ShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYC1ShH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYC1Sg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:36:56 -0400
Received: from vena.lwn.net ([206.168.112.25]:47837 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYC1Sg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:36:56 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Pull] Some documentation patches 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 28 Mar 2008 11:34:38 PDT."
             <alpine.LFD.1.00.0803281132130.14670@woody.linux-foundation.org> 
Date: Fri, 28 Mar 2008 12:36:55 -0600
Message-ID: <14912.1206729415@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That seems to be a pretty recent DNS entry that hasn't percolated out yet. 
> I get "git.lwn.net: NXDOMAIN" to my nslookup query (and git itself 
> obviously says "Name or service not known").
> 
> So you'll need to resend this when it has percolated or send me an IP 
> address ;)

Hmph.  It worked from the machines *I* tried it on...:(

Until the name gets out, pulling:

	git://vena.lwn.net/linux-2.6.git docs

will work.  That name has been out there for eight years or so, should
have percolated by now...

Sorry for the trouble,

jon
