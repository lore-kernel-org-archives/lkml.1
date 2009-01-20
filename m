Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZATKP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZATKP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZATKPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:15:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:60496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753241AbZATKPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:15:06 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19Gs7xgJ5hGI7DhrSCaqGs2pxpKaNCMXOm16b4yiu
	dMEM8W3IDoupXl
Date: Tue, 20 Jan 2009 11:15:03 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Warning and BUG with btrfs and corrupted image
Message-ID: <20090120101503.GC17377@alice>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090120101119.GB10158@disturbed>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 11:14:21 up  4:11,  9 users,  load average: 0.00, 0.02, 0.08
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Chinner (david@fromorbit.com) wrote:
> On Tue, Jan 20, 2009 at 07:31:50AM +0100, Eric Sesterhenn wrote:
> > * Pavel Machek (pavel@suse.cz) wrote:
> > > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > > production' and should survive it...
> > 
> > I regularly (once or twice a week) test 100 corrupted images of 
> > vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> > hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.
> 
> Any reason you are not testing XFS in that set?

So far the responses from xfs folks have been disappointing, if you are
interested in bugreports i can send you some.

Greetings, Eric
