Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZJZSxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZJZSxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbZJZSxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:53:24 -0400
Received: from mail.perches.com ([173.55.12.10]:1059 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZJZSxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:53:21 -0400
Subject: Re: [RFC] scripts/get_maintainer.pl: also find maintainers from
 Mercurial (hg log)
From: Joe Perches <joe@perches.com>
To: Marti Raudsepp <marti@juffo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1256581648.20338.47.camel@newn>
References: <1256573044.7754.20.camel@localhost>
	 <1256578064.1865.96.camel@Joe-Laptop.home> <1256581648.20338.47.camel@newn>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 11:53:24 -0700
Message-ID: <1256583204.1865.108.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 20:27 +0200, Marti Raudsepp wrote:
> On Mon, Oct 26, 2009 at 7:27 PM, Joe Perches <joe@perches.com> wrote:
> > What about using hg annotate for the git blame?
> >        hg annotate -c $file
> Sure, I will get around to it once this patch is done.

I'll integrate this with the latest version and add hg-blame
and submit it via Andrew when he gets back.

cheers, Joe

