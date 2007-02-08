Return-Path: <linux-kernel-owner+w=401wt.eu-S1423275AbXBHTgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423275AbXBHTgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423274AbXBHTgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:36:10 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:25664 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423269AbXBHTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:36:08 -0500
Date: Thu, 8 Feb 2007 20:34:56 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New git server on kernel.org?
Message-ID: <20070208193456.GA9798@osiris.ibm.com>
References: <625fc13d0702080807m1576e3cr152295aa2d88143f@mail.gmail.com> <45CB5DB8.2070104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CB5DB8.2070104@zytor.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 09:28:24AM -0800, H. Peter Anvin wrote:
> Josh Boyer wrote:
> >Hi All,
> >Did the migration of the git stuff to a new dedicated server on
> >kernel.org ever happen?  IIRC, it was supposed to happen the 5th of
> >Feb. or so.
> 
> It hasn't happened yet, no, and since the machine hasn't yet shipped out, it won't happen this week.
> 
> The perils of volunteer labor...

Since yesterday I cannot pull anymore, did something change on kernel.org?

~/linux-2.6> git --version
git version 1.4.2.3
~/linux-2.6> git pull
fatal: unexpected EOF
Fetch failure: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Using http gives me this:

~/linux-2.6> git pull
Fetching refs/heads/master from http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git using http
Getting alternates list for http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
Getting pack list for http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
Getting index for pack f85aaac154270f00327674d01ab0e065566bb3ef
Getting index for pack 4859093553596a353405b0dcf1e0f100216eb4ef
Getting index for pack c00b95c2df806a348994835728350de688418254
Getting index for pack cc4eb5a473f9370255a65e8e29ae6864f631ab1d
Getting index for pack b60c713bd5030f387a6a718edb43deff47f76012
Getting index for pack afa7a654204f6438c28f3b6a37d3c4728cf2bebf
Getting index for pack 323451164326e1d0170b52a437d070cba380a378
Getting pack 323451164326e1d0170b52a437d070cba380a378
 which contains 21d37bbc65e39a26856de6b14be371ff24e0d03f
error: Unable to get pack file http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git//objects/pack/pack-323451164326e1d0170b52a437d070cba380a378.pack
The requested URL returned error: 404
error: Unable to find 21d37bbc65e39a26856de6b14be371ff24e0d03f under http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
Cannot obtain needed none 21d37bbc65e39a26856de6b14be371ff24e0d03f
while processing commit 0000000000000000000000000000000000000000.
