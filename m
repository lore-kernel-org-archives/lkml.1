Return-Path: <linux-kernel-owner+w=401wt.eu-S1751435AbZDGEYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbZDGEYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZDGEXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:23:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbZDGEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:23:34 -0400
Date: Mon, 6 Apr 2009 21:21:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexander Nyberg <alexn@dsv.su.se>
Subject: Re: mmotm 2009-04-05-21-45 uploaded (pageowner)
Message-Id: <20090406212118.f5d9f217.akpm@linux-foundation.org>
In-Reply-To: <20090406210742.fd55e484.randy.dunlap@oracle.com>
References: <200904060450.n364oaUj031923@imap1.linux-foundation.org>
	<20090406210742.fd55e484.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 21:07:42 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Sun, 05 Apr 2009 21:50:36 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-04-05-21-45 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.29:
> 
> 
> I see a few of these build errors:
> 
> build-r2932.out:make[3]: *** No rule to make target `fs/proc/pageowner.o', needed by `fs/proc/proc.o'.  Stop.
> 
> config attached.

Oh well.  I'll drop 'em again.  Various shady individuals are plotting
an ftrace-based feature which will do the same thing.

