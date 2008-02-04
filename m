Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYBDSJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYBDSJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYBDSJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:09:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbYBDSJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:09:09 -0500
Date: Mon, 4 Feb 2008 09:59:10 -0800
From: Greg KH <gregkh@suse.de>
To: "Oliver Pinter (Pint?r Oliv?r)" <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/27] 2.6.22-stable review
Message-ID: <20080204175910.GA22588@suse.de>
References: <20080202001927.GA8368@suse.de> <6101e8c40802040930v7d9dcd85jd37fadd05246664f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802040930v7d9dcd85jd37fadd05246664f@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 06:30:28PM +0100, Oliver Pinter (Pint?r Oliv?r) wrote:
> On 2/2/08, Greg KH <gregkh@suse.de> wrote:
> > This is the start of the stable review cycle for the 2.6.22.17 release.
> > There are 27 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> >
> > These patches are sent out with a number of different people on the
> > Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> > to add your name to the list.  If you want to be off the reviewer list,
> > also email us.
> >
> > Responses should be made by Feb 5 2008, 00:00:00 UTC.  Anything received
> > after that time might be too late.
> >
> > Note, I think this is going to be the last .22 release, unless people
> > send me some patches they think really needs to go in, and then, it will
> > probably only be one more release.  It's time to move on :)
> 
> hmm it is not a long time supperted kernel, like 2.6.16.y ? ;)

No, it was because I wanted to keep it going for a while to make my life
easier at work.  But now I've moved on to another kernel to base things
off of, and don't care so much about .22 :)

thanks,

greg k-h
