Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZAICnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZAICnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZAICnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:43:12 -0500
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:47926
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754574AbZAICnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:43:10 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 21:43:10 EST
Date: Thu, 8 Jan 2009 18:36:29 -0800
From: Phil Oester <kernel@linuxace.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090109023629.GA29520@linuxace.com>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 03:24:40AM +0100, Kay Sievers wrote:
> On Fri, Jan 9, 2009 at 03:11, Phillip Lougher
> <phillip@lougher.demon.co.uk> wrote:
> > Andrew Morton wrote:
> >> Apparently I reviewed the code a while back - that grey cell must have
> >> died.  Does anyone else intend to review the code in that timeframe? If
> >> not, we might as well merge it now, if ever..
> >>
> >
> > I'll be very happy for a merge now, but of course it's not up to me :-(
> 
> I guess, it is hard to find a larger distro that does not merge the
> out-of-tree version to support their live-, and installer-cds. So,
> what argument is preventing a mainline merge now?

Agreed...I'm tired of having to pull along a patch to vanilla kernels
for squashfs.  Drivers are merged that don't even _work_ these days,
so why is there so much concern about merging something which almost
all distros use which impacts almost nothing if you don't enable it???

Phil
