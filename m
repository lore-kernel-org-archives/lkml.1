Return-Path: <linux-kernel-owner+w=401wt.eu-S934074AbXGWXOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074AbXGWXOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbXGWXNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:13:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:54692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934105AbXGWXNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:13:33 -0400
Date: Mon, 23 Jul 2007 15:59:24 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, Takashi Iwai <tiwai@suse.de>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Doug Chapman <doug.chapman@hp.com>, Vasily Tarasov <vtaras@openvz.org>,
       Thierry MERLE <thierry.merle@free.fr>, v4l-dvb-maintainer@linuxtv.org,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.23-rc1: known regressions with patches
Message-ID: <20070723225924.GC25741@suse.de>
References: <46A47940.7030801@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A47940.7030801@googlemail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 11:47:44AM +0200, Michal Piotrowski wrote:
> Unclassified
> 
> Subject         : kobject link failure
> References      : http://lkml.org/lkml/2007/7/19/495
> Last known good : ?

This is caused by a patch that happened after 2.6.22 was released, so it
is a regression.

> Submitter       : Jan Engelhardt <jengelh@linux01.gwdg.de>
> Caused-By       : ?
> Handled-By      : Cornelia Huck <cornelia.huck@de.ibm.com>
>                   Greg Kroah-Hartman <gregkh@suse.de>
> Patch           : http://lkml.org/lkml/2007/7/20/143
> Status          : patch available

I'll be sending Cornelia's patch to Linus within the week to fix this.

thanks,

greg k-h
