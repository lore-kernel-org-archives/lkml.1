Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYJaVvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYJaVvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYJaVvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:51:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbYJaVvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:51:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.28-rc2-git1: spitz still won't boot
Date: Fri, 31 Oct 2008 22:55:37 +0100
User-Agent: KMail/1.9.9
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com
References: <20081031150601.GA1457@ucw.cz>
In-Reply-To: <20081031150601.GA1457@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810312255.38112.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 31 of October 2008, Pavel Machek wrote:
> Hi!
> 
> ...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
> the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
> compile, so bisect is quite hard to do. Any ideas?

Is this a regression from .27?

Rafael
