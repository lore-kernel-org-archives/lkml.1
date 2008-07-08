Return-Path: <linux-kernel-owner+w=401wt.eu-S1751453AbYGHHe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbYGHHe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYGHHew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:34:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42499 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYGHHev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:34:51 -0400
Subject: Re: git pull through http / git
From: "J.H." <warthog19@eaglescrag.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, webmaster@kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>, hpa@kernel.org
In-Reply-To: <487315A3.40302@atmel.com>
References: <48724130.5050501@atmel.com>
	 <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr>
	 <487315A3.40302@atmel.com>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 00:34:32 -0700
Message-Id: <1215502472.1998.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.1.12 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 Jul 2008 00:34:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep in mind Kernel.org uses caching on gitweb and thus gitweb itself is
not necessarily accurate / up to date.  git.kernel.org also round-robins
across 4 machines which may be in various states of update, so your
fundamentally looking at a number of different possible points that may
be slightly out of sync with each other.

- John 'Warthog9' Hawley
Chief Kernel.org Admin & Original Author of the Gitweb Caching code

On Tue, 2008-07-08 at 09:22 +0200, Nicolas Ferre wrote:
> Jan Engelhardt :
> > On Monday 2008-07-07 18:15, Nicolas Ferre wrote:
> > 
> >> Hi,
> >>
> >> I see differences when I use git to a git.kernel.org between the one I fetch
> >> using http protocol and the one shown through the gitweb interface.
> >>
> >> I cloned (or git remote add) the mmc tree and my config shows this url :
> >> url = http://www.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git
> >>
> >> but I see updates in :
> >> http://git.kernel.org/?p=linux/kernel/git/drzeus/mmc.git;a=summary
> >> I cannot get.
> > 
> > I don't think many care about http downloading, just because it is 
> > available as such.
> > git:// and rsync:// are available though and should be usable even 
> > without the http info that needs to be constantly refreshed when one 
> > wants to use http....
> 
> If only I had the choice...
> 
> You certainly know why I am using http. This feature is very useful for 
> me and I was wondering why it was out of sync with the web interface.
> 
> Regards,

