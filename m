Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbXIRPti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbXIRPti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbXIRPtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:49:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38678 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759255AbXIRPta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:49:30 -0400
Date: Tue, 18 Sep 2007 17:50:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070918155046.GA26539@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20159.1190128043@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20159.1190128043@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 11:07:23AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 18 Sep 2007 01:18:41 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> 
> > +gregkh-driver-driver-core-add-config_uevent_helper_path.patch
> 
> So I do a 'make silentoldconfig', and I get:
> 
> *
> * Generic Driver Options
> *
> path to uevent helper (UEVENT_HELPER_PATH) [/sbin/hotplug] (NEW)
> 
> (Hey wow - the patch has a 'help' section, but no '?' listed because it's not a
> bool or tristate. You can apparently get help during 'make menuconfig' but not
> 'make *oldconfig'. That rocks. ;)
Please cc: relevant people next time you complain about kconfig.

Thanks,
	Sam
