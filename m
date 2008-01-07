Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYAGDMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYAGDMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYAGDMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:12:13 -0500
Received: from mmjgroup.com ([192.34.35.33]:38627 "EHLO mmjgroup.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYAGDMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:12:12 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2008 22:12:12 EST
Date: Sun, 6 Jan 2008 20:03:49 -0700
From: LaMont Jones <lamont@mmjgroup.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13.1-rc2
Message-ID: <20080107030348.GA6983@mix.mmjgroup.com>
References: <20080102211052.GC23824@petra.dvoda.cz> <20080105013121.c8bf01ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105013121.c8bf01ed.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 01:31:21AM -0800, Andrew Morton wrote:
> On Wed, 2 Jan 2008 22:10:52 +0100 Karel Zak <kzak@redhat.com> wrote:
> >  The second util-linux-ng 2.13.1 release candidate is available at
> >     ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/
> Interesting.  Thanks.  Which distros are using this, or plan to do so?

Debian's 2.13-13 version is actually 2.13.1-rc2 (looking at
git://git.debian.org/~lamont/util-linux.git) minus the pofile
changes (plus some debian-local stuff), and has been in unstable
since 5 December 2007.  2.13~rc2-3 was the first non-experimental
upload (28 July 2007)

lamont
