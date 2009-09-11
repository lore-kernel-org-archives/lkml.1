Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZIKT4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZIKT4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbZIKT4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:56:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45136 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbZIKT4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:56:39 -0400
Date: Fri, 11 Sep 2009 21:56:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch] zaurus family: battery cleanups
Message-ID: <20090911195635.GD8137@elf.ucw.cz>
References: <20090909073904.GE1327@ucw.cz> <1252507631.14793.113.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252507631.14793.113.camel@desktop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-09 07:47:11, Daniel Walker wrote:
> On Wed, 2009-09-09 at 09:39 +0200, Pavel Machek wrote:
> > This cleans up battery code to conform to codingstyle. The only real
> > change is that we should now refuse to charge if we can't read battery
> > temperature.
> 
> This patch has a number of checkpatch errors. Mostly trailing
> whitespace, or just spacing issues..

Well, original code has problems, too, and I'm trying to slowly clean
that up.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
