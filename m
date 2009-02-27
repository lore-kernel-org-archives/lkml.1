Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZB0SkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZB0SkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZB0Sjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:39:51 -0500
Received: from tau.jukie.net ([216.239.93.128]:43910 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbZB0Sjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:39:51 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Feb 2009 13:39:50 EST
Date: Fri, 27 Feb 2009 13:33:26 -0500
From: Bart Trojanowski <bart@jukie.net>
To: linux-kernel@vger.kernel.org
Subject: where is Documentation/REPORTING-BUGS ?
Message-ID: <20090227183326.GC23376@jukie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into a regression in 2.6.28..2.6.29-rc6 in vlan code.  I am
bisecting it right now.

While that happens, I wanted to check if the proper way to report it is:
via bugzilla or email.  I went to Documentation and looked for related
material.

>From Documentation/BUG-HUNTING...
> Before you submit a bug report read REPORTING-BUGS.

I'd love to, but it's not there.

The only thing I can find is text from 2003, that predates bugzilla.k.o.

        http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html

If that is still official, maybe it could make its way back into the git
tree.  If not, what's today's preferred bug reporting method?

Cheers,
-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
