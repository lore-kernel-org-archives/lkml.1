Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbXGWVny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbXGWVny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932302AbXGWVnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:43:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60366 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153AbXGWVnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:43:37 -0400
Date: Mon, 23 Jul 2007 14:43:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [GIT PATCH 0/2] stripe-queue for 2.6.23 consideration
Message-Id: <20070723144300.8c3f05db.akpm@linux-foundation.org>
In-Reply-To: <20070722094115.18906.64495.stgit@dwillia2-linux.ch.intel.com>
References: <20070722094115.18906.64495.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 02:44:52 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The stripe-queue patches are showing solid performance improvement.
> 
> 	git://lost.foo-projects.org/~dwillia2/git/iop md-for-linus

It's a slippery little tree that one.  I was using md-accel-linus, only I
nuked it because it was empty, or was causing problems or something.

Oh well, I shall switch to md-for-linus and shall see what happens.
