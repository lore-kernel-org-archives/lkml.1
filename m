Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZCKSpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZCKSpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZCKSpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:45:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49861 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZCKSpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:45:32 -0400
Date: Wed, 11 Mar 2009 14:44:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Nico Schottelius <nico-linux-20090311@schottelius.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net,
       Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: X200 suspend status on -wl and -next
Message-ID: <20090311184407.GG8761@tuxdriver.com>
References: <20090311073030.GA5284@denkbrett.schottelius.org> <200903110946.23280.rjw@sisk.pl> <20090311085229.GB4495@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311085229.GB4495@denkbrett.schottelius.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 09:52:29AM +0100, Nico Schottelius wrote:
> Rafael J. Wysocki [Wed, Mar 11, 2009 at 09:46:22AM +0100]:
> > On Wednesday 11 March 2009, Nico Schottelius wrote:
> > > Good morning!
> > > 
> > > vmlinuz-2.6.29-rc7-wl-ikn-32831-g98c5597:
> > 
> > Does -wl stand for 'wireless'?
> 
> Yep:
> 
> ikn% grep url .git/config 
>   url = git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Any chance you'd like to try wireless-testing to help to isolate
possible sources of this problem?

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
