Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbYG3Ik0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbYG3Ik0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYG3IkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:40:16 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:34701 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbYG3IkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:40:15 -0400
Date: Wed, 30 Jul 2008 10:40:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] docsrc: fix crc32hash type
Message-ID: <20080730084005.GC18366@uranus.ravnborg.org>
References: <12173619152424@xenotime.net> <1217361915584@xenotime.net> <20080730064720.GA13409@isilmar.linta.de> <20080730001850.c24fc671.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730001850.c24fc671.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 12:18:50AM -0700, Andrew Morton wrote:
> On Wed, 30 Jul 2008 08:47:20 +0200 Dominik Brodowski <linux@dominikbrodowski.net> wrote:
> 
> > Hi,
> > 
> > On Tue, Jul 29, 2008 at 01:05:15PM -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Fix differing signedness warning:
> > > 
> > > Documentation/pcmcia/crc32hash.c:29: warning: pointer targets in passing argument 1 of 'crc32' differ in signedness
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
> > 
> > Shall this go in via the pcmcia git tree, or with the other doc patches?
> > 
> 
> I was planning on merging them up in a week or so, if they don't appear
> in anyone else's tree.
Would be good.
I would usually postpone this till next merge window if I
carried them in a kbuild tree.

	Sam
