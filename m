Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbYFGTQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbYFGTQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYFGTQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:16:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbYFGTQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:16:03 -0400
Date: Sat, 7 Jun 2008 12:13:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben@fluff.org>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Harald Welte <laforge@openmoko.org>, Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>
Subject: Re: [patch 01/15] MMC: S3C24XX MMC/SD driver. From: Thomas Kleffel
 <tk@maintech.de>
Message-Id: <20080607121359.50dd7b54.akpm@linux-foundation.org>
In-Reply-To: <20080607122227.GA1500@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
	<20080606155524.699256747@fluff.org.uk>
	<20080606224928.a3ac2655.akpm@linux-foundation.org>
	<20080607122227.GA1500@fluff.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc's restored.  Please don't remove people)

On Sat, 7 Jun 2008 13:22:27 +0100 Ben Dooks <ben@fluff.org> wrote:

> > right at the top of the changelog so that the commit is correctly
> > attributed.
> > 
> > > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > 
> > Please pass these patches through chechpatch?  This one alone generates
> > 
> > total: 40 errors, 29 warnings, 1488 lines checked
> > 
> > many of which you would have fixed had you been aware of them.  That's
> > what checkpatch is for.
> 
> Is it ok to fit another patch after this one to fixup these problems?

OK by me, as would be a new patch.

Pierre would be merging this (might have already done so?) - I assume
he'd prefer a whole new patch.
