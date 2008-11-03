Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbYKCHg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbYKCHg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYKCHgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:36:51 -0500
Received: from molly.corsac.net ([81.57.48.219]:39500 "EHLO molly.corsac.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbYKCHgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:36:50 -0500
Date: Mon, 3 Nov 2008 08:36:47 +0100
From: Yves-Alexis Perez <corsac@debian.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081103073647.GB6313@corsac.net>
References: <200810281744.52587.elendil@planet.nl> <200810290153.23514.elendil@planet.nl> <4907D957.6040206@linux.intel.com> <20081029065428.GA15581@corsac.net> <20081029071143.GA15736@corsac.net> <20081103072327.GA6313@corsac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103072327.GA6313@corsac.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 08:23:27AM +0100, Yves-Alexis Perez wrote:
> FTR, it seems fixed in 2.6.28-rc3 (I just git pull-ed the tree, so I
> don't know which commit has fixed the problem)
> 
> Could anyone (Frans?) confirm this?


Hmhm ok, it's *not* fixed, it just appears a bit better, but it's still
slow and hangs during boot process until I type some random keys.
-- 
Yves-Alexis
