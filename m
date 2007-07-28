Return-Path: <linux-kernel-owner+w=401wt.eu-S933991AbXG1GRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbXG1GRs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXG1GRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:17:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:62174 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbXG1GRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QxgvCM7to/AKsw0THRe5loKvGhZQ8amTWwGcMMfnllYP+rMfc5oZB6TslVFmv0FvD/696bb/MLcvUZcAERwE8FL9FTZUoOLIJafWdTjx0bK9V6Px0seYzlD+/mUxHhZ1lSl7VmwYng8C18dFqkGMTz+gSJCUZ3x3eqj6GOiK5hg=
Message-ID: <a44ae5cd0707272317n7de15282y37f13b57cb794db8@mail.gmail.com>
Date: Fri, 27 Jul 2007 23:17:39 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: =?WINDOWS-1252?Q?Re:_mm/sparse.c:482:_error:_implicit_declara?= =?WINDOWS-1252?Q?tion_of_function_=91sparse=5Fearly=5Fusemap=5Falloc=92?=
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070728061523.GG15129@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0707272300y85825d0v9b8ff60de0de50a0@mail.gmail.com>
	 <20070728061523.GG15129@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Fri, Jul 27, 2007 at 11:00:54PM -0700, Miles Lane wrote:
> > Do you need my .config file?
>
> Please always send the .config - it makes reproducing an error and
> verifying a fix much easier.
>
> This list has a 400 kB per email limit, and as long as you don't hit
> this limit you have never sent too much information.
>
> >   CC      mm/sparse.o
> > mm/sparse.c: In function 'sparse_init':
> > mm/sparse.c:482: error: implicit declaration of function
> > 'sparse_early_usemap_alloc'
> > mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> > make[1]: *** [mm/sparse.o] Error 1
>
> The .config also tells which kernel you are using.
>
> This doesn't seem to be Linus' tree.
> This seems to be 2.6.23-rc1-mm1?

Rats.  I almost always remember to specify the kernel version.
Sorry.  Yes, it's the Andrew's latest tree, plus hotfixes.

            Miles
