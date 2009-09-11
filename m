Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZIKVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZIKVDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZIKVDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:03:36 -0400
Received: from fifo99.com ([67.223.236.141]:59806 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617AbZIKVDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:03:35 -0400
Subject: Re: [patch] zaurus family: battery cleanups
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20090911195635.GD8137@elf.ucw.cz>
References: <20090909073904.GE1327@ucw.cz>
	 <1252507631.14793.113.camel@desktop>  <20090911195635.GD8137@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 14:04:10 -0700
Message-Id: <1252703050.28368.26.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 21:56 +0200, Pavel Machek wrote:
> On Wed 2009-09-09 07:47:11, Daniel Walker wrote:
> > On Wed, 2009-09-09 at 09:39 +0200, Pavel Machek wrote:
> > > This cleans up battery code to conform to codingstyle. The only real
> > > change is that we should now refuse to charge if we can't read battery
> > > temperature.
> > 
> > This patch has a number of checkpatch errors. Mostly trailing
> > whitespace, or just spacing issues..
> 
> Well, original code has problems, too, and I'm trying to slowly clean
> that up.

Ok, but your adding new problems to the code .. So eventually these new
problems would also need to get cleaned up.. If you don't add new
problems and just clean up old problems, then your moving in the right
direction (eventually no problems at all) ..

Daniel

