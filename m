Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYHGSww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYHGSww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYHGSwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:52:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36121 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYHGSwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:52:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: Tree for July 30
Date: Thu, 7 Aug 2008 20:55:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       bzolnier@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731131056.eecc4826.akpm@linux-foundation.org> <20080807140357.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080807140357.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808072055.30072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of August 2008, Dmitry Torokhov wrote:
> On Thu, Jul 31, 2008 at 01:10:56PM -0700, Andrew Morton wrote:
> > 
> > If that works then great.  But I think the printk could be improved. 
> > Please provide sufficient information so that users (not programmers)
> > can go off and fix things up without needing to email kernel developers.
> > 
> > One suitable approach would be
> > 
> > 	printk("see http://userweb.kernel.org/~dtor/read-this.txt")
> > 
> 
> Ok, I made a small page here:
> 
> 	http://userweb.kernel.org/~dtor/eviocgbit-bug.html

404: Not Found

> If you think this is sufficient I'd like to put the patch with the
> warning in 2.6.27 so people and distributions could start updarting
> affected programs.
