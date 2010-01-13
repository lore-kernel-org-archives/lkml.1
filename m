Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140Ab0AMNjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0AMNjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993Ab0AMNji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:39:38 -0500
Received: from ns.penguin.cz ([84.21.108.25]:53717 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab0AMNji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:39:38 -0500
Subject: Re: Possible suspend/resume regression in .32-rc?
From: Stanislav Brabec <utx@penguin.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric <eric.y.miao@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de, gregkh@suse.de,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       kernel list <linux-kernel@vger.kernel.org>, dsaxena@laptop.org,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       thommycheck@gmail.com, Dirk@opfer-online.de,
       linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
In-Reply-To: <20100113114651.GJ8970@buzzloop.caiaq.de>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
	 <20091101205449.GT14091@buzzloop.caiaq.de>
	 <20091101213343.GA31345@elf.ucw.cz> <20091101220341.GA16698@elf.ucw.cz>
	 <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
	 <1257155873.5642.14.camel@utx.utx.cz>
	 <771cded00911021931x41cfa51bh2959d3748db5ac0@mail.gmail.com>
	 <1257241821.4269.5.camel@utx.utx.cz>
	 <771cded00911042106u39fd3655mae50a89bd419411b@mail.gmail.com>
	 <20100113114651.GJ8970@buzzloop.caiaq.de>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Wed, 13 Jan 2010 14:42:41 +0100
Message-Id: <1263390161.5419.9.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:

> It seems Stanislav's patch is still unmerged in the current git HEAD.
> Any idea why it is held back? I have it applied locally since quite a
> while here, and it works well. So if it helps, take my Tested-by: for
> it.

It seems to be on the right way:

From: gregkh@suse.de
Subject: patch serial-core-resume-serial-hardware-with-no_console_suspend.patch added to gregkh-2.6 tree
Date: Tue, 22 Dec 2009 12:22:35 -0800

This is a note to let you know that I've just added the patch titled

    Subject: serial-core: resume serial hardware with no_console_suspend

to my gregkh-2.6 tree.  Its filename is

    serial-core-resume-serial-hardware-with-no_console_suspend.patch

This tree can be found at 

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

