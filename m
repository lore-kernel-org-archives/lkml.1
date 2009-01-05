Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZAEO7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZAEO7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZAEO6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:58:55 -0500
Received: from vps1.tull.net ([66.180.172.116]:34825 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754396AbZAEO6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:58:54 -0500
Date: Tue, 6 Jan 2009 01:58:49 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix incorrect use of loose in hfs.txt
Message-ID: <20090105145849.GA19272@mail.local.tull.net>
References: <20081205030758.31888.30272.stgit@marcab.local.tull.net> <20081222110633.ea77cad9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222110633.ea77cad9.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 11:06:33AM -0800, Randy Dunlap wrote:
> For any of these patches that were not picked up/merged/applied by someone,
> maybe you should resend them to lkml/wherever and cc: trivial@kernel.org:

Yes, I'll check again in a couple of months. More recently I posted
a bunch of typo fixes to lkml + trivial and that's a lot easier for
me to do than sending each patch to a maintainer. Any patch which
fails to merge due to real work in an affected file can be dropped
and resubmitted later.

Nick.
