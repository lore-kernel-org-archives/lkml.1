Return-Path: <linux-kernel-owner+w=401wt.eu-S1765327AbXFSAKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765327AbXFSAKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbXFSAKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:10:24 -0400
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:50010
	"EHLO cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbXFSAKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:10:23 -0400
X-Greylist: delayed 2235 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 20:10:23 EDT
Date: Mon, 18 Jun 2007 14:24:23 -0700
From: Brad Boyer <flar@allandria.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       alan <alan@clueserver.org>, Bodo Eggert <7eggert@gmx.de>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618212423.GB19713@cynthia.pants.nu>
References: <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org> <20070618222656.GB25089@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618222656.GB25089@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 12:26:57AM +0200, Jörn Engel wrote:
> Pointless here means that _I_ don't see the point.  Maybe there are
> valid uses for extended attributes.  If there are, noone has explained
> them to me yet.

The users of extended attributes that I've dealt with are ACL support
and SELinux. These both use extended attributes under the covers. It's
just not immediately obvious if you aren't looking.

	Brad Boyer
	flar@allandria.com

