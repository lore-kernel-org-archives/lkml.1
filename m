Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZIWRk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZIWRk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZIWRky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:40:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:38121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZIWRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:40:54 -0400
Date: Wed, 23 Sep 2009 10:34:28 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oliver Neukum <oliver@neukum.org>,
       Elina Pasheva <epasheva@sierrawireless.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] USB sierra: Fix build if
	!CONFIG_PM
Message-ID: <20090923173428.GA7528@kroah.com>
References: <20090923135539.GA6542@kroah.com> <20090923172456.GA8948@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923172456.GA8948@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 07:24:56PM +0200, Ingo Molnar wrote:
> 
> >       USB: support for autosuspend in sierra while online
> 
> FYI, -tip testing found a build failure with the sierra driver on 
> !CONFIG_PM - fixed via the patch below.
> 

Thanks, I'll queue this up when I get back from the Plumbers conference
this week.

greg k-h
