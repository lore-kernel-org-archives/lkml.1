Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZI2Krd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZI2Krd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZI2Krd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:47:33 -0400
Received: from trinity.fluff.org ([89.16.178.74]:56735 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbZI2Krc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:47:32 -0400
Date: Tue, 29 Sep 2009 11:47:35 +0100
From: Ben Dooks <ben@simtec.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ben@fluff.org, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net
Subject: Re: gpiolib: add names file in gpio chip sysfs.
Message-ID: <20090929104734.GL2698@trinity.fluff.org>
References: <20090803165536.345974601@fluff.org> <20090804164339.99667a23.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804164339.99667a23.akpm@linux-foundation.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 04:43:39PM -0700, Andrew Morton wrote:
> On Mon, 03 Aug 2009 17:55:36 +0100
> ben@fluff.org wrote:
> >
> 
> Did you mean the commit to have an author of ben@fluff.org?  I assumed
> not and rewrote it to
> 
> 	Ben Dooks <ben@simtec.co.uk>
> 
> If you indeed want a different Author: and Signed-off-by: line then
> please indicate that explicitly by putting a From: line at the top of
> the changelog.

sorry, occasionally whilst using quilt mail I get this wrong.
 
> As your MUA didn't fill in the real-name part of the From: address,
> it's nice to provide a From: line in the changelog so the patch
> receiver doesn't have to type it in.
> 
> > Add a 'names' file to the sysfs entries for each chip to show which
> > have names.
> 
> Why?

To export this information to the user. That was the only reason.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

