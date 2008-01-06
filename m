Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYAFP1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYAFP1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYAFP1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:27:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYAFP1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:27:12 -0500
Date: Sun, 6 Jan 2008 16:27:06 +0100
From: Karel Zak <kzak@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13.1-rc2
Message-ID: <20080106152706.GD31215@petra.dvoda.cz>
References: <20080102211052.GC23824@petra.dvoda.cz> <20080105013121.c8bf01ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105013121.c8bf01ed.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 01:31:21AM -0800, Andrew Morton wrote:
> On Wed, 2 Jan 2008 22:10:52 +0100 Karel Zak <kzak@redhat.com> wrote:
> 
> > 
> > 
> >  The second util-linux-ng 2.13.1 release candidate is available at
> > 
> >     ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/
> > 
> 
> Interesting.  Thanks.  Which distros are using this, or plan to do so?

 According to Mr.Google:

    Ubuntu, Debian, Mandriva, Gentoo, Fedora, Suse, Frugalware,
    Archlinux, ...

 Thanks to people from Debian, Gentoo, Suse, Red Hat and the others who
 actively help with util-linux-ng project in last year.

 $ git log --pretty=format:"%an" | sort -u | wc -l
 50

 ;-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
