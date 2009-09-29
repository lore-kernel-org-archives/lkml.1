Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZI2TfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZI2TfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZI2TfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:35:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbZI2TfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:35:15 -0400
Date: Tue, 29 Sep 2009 12:34:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben@simtec.co.uk>
Cc: ben@fluff.org, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net
Subject: Re: gpiolib: add names file in gpio chip sysfs.
Message-Id: <20090929123416.06e5a381.akpm@linux-foundation.org>
In-Reply-To: <20090929104734.GL2698@trinity.fluff.org>
References: <20090803165536.345974601@fluff.org>
	<20090804164339.99667a23.akpm@linux-foundation.org>
	<20090929104734.GL2698@trinity.fluff.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 11:47:35 +0100
Ben Dooks <ben@simtec.co.uk> wrote:

> On Tue, Aug 04, 2009 at 04:43:39PM -0700, Andrew Morton wrote:
> > On Mon, 03 Aug 2009 17:55:36 +0100
> > ben@fluff.org wrote:
> > >
> > 
> > Did you mean the commit to have an author of ben@fluff.org?  I assumed
> > not and rewrote it to
> > 
> > 	Ben Dooks <ben@simtec.co.uk>
> > 
> > If you indeed want a different Author: and Signed-off-by: line then
> > please indicate that explicitly by putting a From: line at the top of
> > the changelog.
> 
> sorry, occasionally whilst using quilt mail I get this wrong.
>  
> > As your MUA didn't fill in the real-name part of the From: address,
> > it's nice to provide a From: line in the changelog so the patch
> > receiver doesn't have to type it in.
> > 
> > > Add a 'names' file to the sysfs entries for each chip to show which
> > > have names.
> > 
> > Why?
> 
> To export this information to the user. That was the only reason.
> 

hm, OK.  I guess I just won't be understanding what value this patch
has.  Hopefully more gpio-inclined people do.

What's the status of this patch now?  I have a note that David had
issues with it - did they get resolved somehow?

