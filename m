Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZBTDgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZBTDgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZBTDgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:36:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:45013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZBTDgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:36:14 -0500
Date: Thu, 19 Feb 2009 19:35:59 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [patch 03/36] Fix Intel IOMMU write-buffer flushing
Message-ID: <20090220033559.GA32562@suse.de>
References: <20090218222447.432108614@mini.kroah.org> <20090218222901.GD10668@kroah.com> <499C9394.5030704@mandriva.org> <499DF274.8040702@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499DF274.8040702@mandriva.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 01:59:48AM +0200, Thomas Backlund wrote:
> Thomas Backlund skrev:
>> This patch is broken compared to what's in:
>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ca77fde8e62cecb2c0769052228d15b901367af8 
>> attached patch fixes it
>
> As no-one responded yet...

Sorry for the delay, you're right, I messed this one up.  I'll merge
your fix into the patch before doing the release tomorrow.

Thanks for letting us know.

greg k-h
