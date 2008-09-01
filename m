Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYIARxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYIARxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYIARw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:52:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34953 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYIARw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:52:58 -0400
Date: Mon, 1 Sep 2008 19:52:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Cc: "Gene Heskett" <gene.heskett@verizon.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaswinder Singh" <jaswinder@infradead.org>, xorg@lists.freedesktop.org,
       davem@davemloft.net, torvalds@linux-foundation.org, nhaehnle@gmail.com,
       airlied@linux.ie, glisse@freedesktop.org, tony@bakeyournoodle.com
Subject: Re: Linux-2.6.27-rc5, drm errors in log
Message-ID: <20080901195225.3dcc50bc@hyperion.delvare>
In-Reply-To: <3f9a31f40809010934k468914d8sc43f323e9f32e9e7@mail.gmail.com>
References: <200808301452.04634.gene.heskett@verizon.net>
	<3f9a31f40809010934k468914d8sc43f323e9f32e9e7@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 12:34:28 -0400, Jaswinder Singh wrote:
> Hello Gene,
> 
> On Sat, Aug 30, 2008 at 2:52 PM, Gene Heskett <gene.heskett@verizon.net> wrote:
> >
> > A re-repeat of a previous posting which has not drawn a comment. With added
> > content, added CC to a patch author, and some new questions.
> >
> 
> This is not because of my radeon firmware patch, my patch is still in
> pipeline. Here is the list of developers who played with radeon :-
> 
> 1. 4 days ago 	Linus Torvalds 	Merge branch 'drm-patches' of
> git://git.kernel.org ...
> 2. 7 days ago 	Nicolai Haehnle 	drm/radeon: r300_cmdbuf: Always emit
> INDX_BUFFER immediately ...
> 3. 7 days ago 	Jerome Glisse 	radeon: fix some hard lockups on r3/4/500s
> 4. 2008-08-12 	David Miller 	radeonfb: fix accel engine hangs
> 5. 2008-08-05 	Jean Delvare 	radeonfb: give i2c buses nicer names
> 6. 2008-08-05 	David Miller 	radeon: misc corrections
> 7. 2008-07-24 	Tony Breeds 	drivers/video/aty/radeon_base.c: notify
> user if sysfs ...

radeonfb != drm/radeon

-- 
Jean Delvare
