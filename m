Return-Path: <linux-kernel-owner+w=401wt.eu-S1763895AbXFKAVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763895AbXFKAVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 20:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760540AbXFKAVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 20:21:44 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58895 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbXFKAVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 20:21:43 -0400
Date: Mon, 11 Jun 2007 02:21:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Diego Calleja <diegocg@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@suse.de>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO
	translated into Japanese]
Message-ID: <20070611002154.GE3588@stusta.de>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <20070610175228.GA28947@uranus.ravnborg.org> <20070610214138.3d17be8a.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070610214138.3d17be8a.diegocg@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 09:41:38PM +0200, Diego Calleja wrote:
> El Sun, 10 Jun 2007 19:52:28 +0200, Sam Ravnborg <sam@ravnborg.org> escribió:
> 
> > I advocated that they should stay out back then.
> > But on the other hand I do not see it causing much troubles
> > having scripts/kconfig/po/da.po etc araound.
> > 
> > Any opinion about the .po files?
> 
> These days the configuration menus are not something that users need to
> read, they're more like a developer tool. IMO there's not much value in it,
> because the people who read it already know english most of the times.

The majority of Kconfig users are _not_ kernel developers.

There are many different reasons why people compile their own kernel, 
and "sysadmin who knows his hardware and the filesystems of his disks" 
is really sufficient for compiling your own kernel.

Whether non-English Kconfig texts are important might be a question, but 
if there are people doing the translation work there's no problem with 
it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

