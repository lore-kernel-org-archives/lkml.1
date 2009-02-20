Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZBTN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZBTN7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZBTN7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:59:10 -0500
Received: from mbox2.netikka.net ([213.250.81.203]:47531 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZBTN7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:59:09 -0500
Message-ID: <499EB6B0.6040703@mandriva.org>
Date: Fri, 20 Feb 2009 15:57:04 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Thomas Backlund <tmb@mandriva.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [patch 03/36] Fix Intel IOMMU write-buffer flushing
References: <20090218222447.432108614@mini.kroah.org> <20090218222901.GD10668@kroah.com> <499C9394.5030704@mandriva.org> <499DF274.8040702@mandriva.org> <20090220033559.GA32562@suse.de>
In-Reply-To: <20090220033559.GA32562@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH skrev:
> On Fri, Feb 20, 2009 at 01:59:48AM +0200, Thomas Backlund wrote:
>> Thomas Backlund skrev:
>>> This patch is broken compared to what's in:
>>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ca77fde8e62cecb2c0769052228d15b901367af8 
>>> attached patch fixes it
>> As no-one responded yet...
> 
> Sorry for the delay, you're right, I messed this one up.  I'll merge
> your fix into the patch before doing the release tomorrow.
> 

OK, Thanks.

> Thanks for letting us know.
> 


No problem....

I see you have the same patch & bug in the 2.6.28.7-rc1, so it needs the 
same fix...

The patch I already sent will apply with fuzz, but is applied correctly

--
Thomas
