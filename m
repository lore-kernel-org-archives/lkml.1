Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYIHP7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYIHP7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYIHP6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:58:51 -0400
Received: from josefsipek.net ([141.211.133.196]:42157 "EHLO josefsipek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbYIHP6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:58:51 -0400
Date: Mon, 8 Sep 2008 11:58:50 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: Michael J Gruber <michaeljgruber+gmane@fastmail.fm>
Cc: Git Mailing List <git@vger.kernel.org>, linux-kernel@vger.kernel.org,
       guilt@lists.josefsipek.net
Subject: Re: [ANNOUNCE] Guilt v0.31
Message-ID: <20080908155850.GD27550@josefsipek.net>
References: <20080908135244.GB27550@josefsipek.net> <48C54728.1030809@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C54728.1030809@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 05:39:20PM +0200, Michael J Gruber wrote:
> Josef 'Jeff' Sipek venit, vidit, dixit 08.09.2008 15:52:
> > Guilt v0.31 is available for download.
> > 
> > Guilt (Git Quilt) is a series of bash scripts which add a Mercurial
> > queues-like functionality and interface to git.
> > 
> > Tarballs:
> > http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/
> > 
> > Git repo:
> > git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/guilt.git
> > 
> > 
> > This is a mostly bugfixes-only release to get the fixes that accumulated
> > over the past several months out of the door.
> > 
> > As always, patches, and other feedback is welcome.
> > 
> > Josef "Jeff" Sipek.
> 
> Guilt insists on being used with git 1.5.*. Is this intended?

Ok, I committed v0.31.1.

Thanks for noticing!

Josef 'Jeff' Sipek.

-- 
The reasonable man adapts himself to the world; the unreasonable one
persists in trying to adapt the world to himself. Therefore all progress
depends on the unreasonable man.
		- George Bernard Shaw
