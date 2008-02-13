Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbYBMRD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbYBMRD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764542AbYBMRC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:02:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:47543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761586AbYBMRCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:02:55 -0500
Date: Wed, 13 Feb 2008 08:59:24 -0800
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-ID: <20080213165924.GB10129@suse.de>
References: <20080213070215.GA11969@kroah.com> <20080212.230423.172781444.davem@davemloft.net> <1202887323.3129.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202887323.3129.10.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:22:02PM -0800, Joe Perches wrote:
> On Tue, 2008-02-12 at 23:04 -0800, David Miller wrote:
> > > In the big "linux-next" series of emails, David Miller suggested that
> > > the feature-removal-schedule file be broken up into little pieces, as it
> > > is causing merge problems for different trees.
> 
> I suggest the same for MAINTAINERS

Why, is it a merge problem for you?

I've merged lots of new entries into it over the years, and never had a
problem with it, but that just might be me...

thanks,

greg k-h
