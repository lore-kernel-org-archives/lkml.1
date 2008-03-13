Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYCMMHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYCMMHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYCMMGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:06:55 -0400
Received: from styx.suse.cz ([82.119.242.94]:52602 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753597AbYCMMGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:06:54 -0400
Date: Thu, 13 Mar 2008 13:06:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: Mike Galbraith <efault@gmx.de>, Jan Knutar <jk-lkml@sci.fi>,
       linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
       David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
       "Fred ." <eldmannen@gmail.com>
Subject: Re: Keys get stuck
In-Reply-To: <20080313120238.GA3860@localhost.ift.unesp.br>
Message-ID: <Pine.LNX.4.64.0803131305540.30831@jikos.suse.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
 <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net>
 <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net>
 <20080313120238.GA3860@localhost.ift.unesp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Carlos R. Mafra wrote:

> So I would like to ask if swap letting X (and everything else in my 
> experience) out of the cpu for extended periods is considered normal 
> behaviour, in the sense that nobody is trying to "fix" it (due to it 
> being considered impossible to fix)...? Sorry for being off-topic, but I 
> run a minimal Window Maker desktop in a P4 3.0 GHz with 512 MB of RAM 
> (around 140 MB being used as per 'free'), and trying to load a 380 MB 
> text file in xjed editor makes my whole desktop quite unfair... it takes 
> tens of seconds to switch desktop, type things in the terminal etc. When 
> xjed finishes loading the text file, everything comes back to "fair" 
> again.

I propose you start a new thread about this with proper Subject, and CC 
the scheduler maintainers.

Thanks,

-- 
Jiri Kosina
SUSE Labs
