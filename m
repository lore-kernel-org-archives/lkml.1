Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZEEVFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZEEVFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZEEVFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:05:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZEEVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:05:04 -0400
Date: Tue, 5 May 2009 17:04:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tridge@samba.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>,
       Olivier Galibert <galibert@pobox.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090505210438.GA1325@infradead.org>
References: <20090504132119.GX8822@parisc-linux.org> <20090504143919.GA6740@linux.vnet.ibm.com> <20090504150834.GZ8822@parisc-linux.org> <1241451391.20170.12.camel@norville.austin.ibm.com> <m14ow0hnal.fsf@fess.ebiederm.org> <1241453259.20170.17.camel@norville.austin.ibm.com> <m1k54wal0j.fsf@fess.ebiederm.org> <20090504230357.GI6766@mit.edu> <4A001E51.4070903@davidnewall.com> <109151.1241556990@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <109151.1241556990@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 04:56:30PM -0400, Valdis.Kletnieks@vt.edu wrote:
> Well, VFAT was in Windows for Workgroups 3.11 or so, back in 1982, and a patent

VFAT was introduced in Windows 95.  OS/2 had it's own long filename
extensions longe before as did Linux (umsdos)

