Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZJZTbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZJZTbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZJZTbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:31:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35569 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbZJZTbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:31:14 -0400
Date: Mon, 26 Oct 2009 15:20:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026192026.GI2792@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com> <20091026172434.GI25725@elf.ucw.cz> <20091026184818.GB21591@suse.de> <1256584063.1865.118.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256584063.1865.118.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 12:07:43PM -0700, Joe Perches wrote:
> On Mon, 2009-10-26 at 11:48 -0700, Greg KH wrote:
> > On Mon, Oct 26, 2009 at 06:24:34PM +0100, Pavel Machek wrote:
> > > Anyway, for moving to staging, TODO file describing what needs to be
> > > fixed before it is brought back was listed as a requirement.
> > 	- A maintainer is needed to take ownership of this driver and
> > 	  they must be willing to maintain and test any future api
> > 	  changes needed.
> 
> There are a lot of files in the tree without assigned maintainers.
> (want a list? ;)
> 
> I think adding a requirement that files have maintainers before
> being added to not-staging is not a good thing.

This is not a blanket policy.  Please don't imply that it is.

> It is likely that strip could have be deleted without anyone caring.

Perhaps so...how would that be better?  It would be less work for Greg,
but he seems to be fine with this...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
