Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbZGHGzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbZGHGzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759450AbZGHGzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:55:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36400 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZGHGzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:55:04 -0400
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <1247035628.5124.11.camel@Joe-Laptop.home>
References: <cover.1247032324.git.joe@perches.com>
	 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
	 <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
	 <1247035197.5124.9.camel@Joe-Laptop.home>
	 <1247035481.15919.31.camel@penberg-laptop>
	 <1247035628.5124.11.camel@Joe-Laptop.home>
Date: Wed, 08 Jul 2009 09:55:02 +0300
Message-Id: <1247036102.15919.41.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 2009-07-07 at 23:39 -0700, Joe Perches wrote:
> > > Documentation/SubmittingPatches already states that
> > > LKML should be CC'd on all patches.

On Wed, 2009-07-08 at 09:44 +0300, Pekka Enberg wrote:
> > Maybe it does, but real world doesn't seem to agree with you here.

On Tue, 2009-07-07 at 23:47 -0700, Joe Perches wrote:
> Well, if scripts/get_maintainer.pl gets used more often,
> it would.

And kernel hackers could fly if they had wings.

Look, all I care is that people who send patches to subsystems I
maintain know what to CC. The get_maintainer.pl script is obviously
really helpful here but the fact is, it's _not_ mandatory to CC LKML for
all patches. So I worry that people will be confused and no list is CC'd
because other subsystems that have a separate mailing list have that in
MAINTAINERS.

But anyway, no need to argue about this, Andrew merged your first patch
so the second patch makes sense as well.

			Pekka

