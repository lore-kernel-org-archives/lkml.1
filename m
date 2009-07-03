Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZGCKxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZGCKxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZGCKxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:53:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbZGCKxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:53:40 -0400
Date: Fri, 3 Jul 2009 12:53:41 +0200
From: Karel Zak <kzak@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.16-rc2
Message-ID: <20090703105341.GE4122@nb.net.home>
References: <20090702181031.GB4122@nb.net.home> <ac3eb2510907021332l2d0c1908s19d01c994f42b549@mail.gmail.com> <1246613381.1923.9.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246613381.1923.9.camel@yio.site>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 11:29:41AM +0200, Kay Sievers wrote:
> On Thu, 2009-07-02 at 22:32 +0200, Kay Sievers wrote:
> This seems to make it work in the chroot.
> 
> It turns around the logic, and installs the libs in /usr, and moves
> the .so to /, so the devel links and the .la files are not changed.

 Yes, this is probably the best solution. (I'll also rename
 usrlibexecdir, that's too confusing.)

 Thanks!

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
