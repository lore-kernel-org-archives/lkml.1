Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZJZTHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZJZTHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZJZTHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:07:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1063 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbZJZTHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:07:39 -0400
Subject: Re: [PATCH 1/4] strip: move driver to staging
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091026184818.GB21591@suse.de>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
	 <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com>
	 <20091026172434.GI25725@elf.ucw.cz>  <20091026184818.GB21591@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 12:07:43 -0700
Message-ID: <1256584063.1865.118.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 11:48 -0700, Greg KH wrote:
> On Mon, Oct 26, 2009 at 06:24:34PM +0100, Pavel Machek wrote:
> > Anyway, for moving to staging, TODO file describing what needs to be
> > fixed before it is brought back was listed as a requirement.
> 	- A maintainer is needed to take ownership of this driver and
> 	  they must be willing to maintain and test any future api
> 	  changes needed.

There are a lot of files in the tree without assigned maintainers.
(want a list? ;)

I think adding a requirement that files have maintainers before
being added to not-staging is not a good thing.

It is likely that strip could have be deleted without anyone caring.

