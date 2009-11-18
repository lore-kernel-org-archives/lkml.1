Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZKRQEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZKRQEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbZKRQEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:04:54 -0500
Received: from mail.crlf.net ([216.235.14.184]:64752 "EHLO mail.crlf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496AbZKRQEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:04:54 -0500
X-Greylist: delayed 1524 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Nov 2009 11:04:54 EST
Date: Wed, 18 Nov 2009 10:39:35 -0500
From: David Maxwell <dmaxwell@coverity.com>
To: jirislaby@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Coverity checking periodicity?
Message-ID: <20091118153935.GA6796@mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote, On Tue, 17 Nov 2009 09:34:36 +0100:
> please, doesn't anybody have an idea on how often is Coverity run on the
> kernel? Doesn't anybody know about any materials regarding this?

Hello Jiri,

When the build systems are running smoothly, builds are done daily off
the git head of tree.

The Linux build was hung up at the moment - so Sep 14th 2009 was the most
recent build. I've kicked off a fresh build now and I'll see if there are
any errors with it.

You mentioned the stats on the Scan site not being updated. That's true.
I haven't had time to do maintenance on the relevant scripts in quite a while,
so the site doesn't reflect the ongoing builds and defect count changes. :-(

--
David Maxwell
Coverity Open Source Strategist
http://scan.coverity.com/
