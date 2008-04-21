Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbYDUPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbYDUPz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbYDUPzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:55:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40147 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbYDUPzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:55:11 -0400
Date: Mon, 21 Apr 2008 18:54:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
Subject: Re: [PATCH 29/37] Input: fix ordering in joystick Makefile
Message-ID: <20080421155440.GK6011@cs181133002.pp.htv.fi>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com> <1b8930dc64b6842e50711441ba67482aacc475dd.1208783694.git.dmitry.torokhov@gmail.com> <20080421142245.GI6011@cs181133002.pp.htv.fi> <20080421153910.GA6884@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080421153910.GA6884@anvil.corenet.prv>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:39:10AM -0400, Dmitry Torokhov wrote:
> On Mon, Apr 21, 2008 at 05:22:45PM +0300, Adrian Bunk wrote:
>...
> > BTW: The From: and To: headers in your emails were not correct.
> 
> My fault. I was trying to use git-format-patch and formail and screwed
> up. Why doesn't git-format-patch allow specify To: but only Cc:?

Note that the From: headers had a different problem:

  From: Jiri Kosina <dmitry.torokhov@gmail.com>
        ^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^^

> Dmitry

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

