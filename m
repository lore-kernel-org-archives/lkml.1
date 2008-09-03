Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYICSLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYICSLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYICSLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:11:24 -0400
Received: from [76.245.85.235] ([76.245.85.235]:52119 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbYICSLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:11:22 -0400
Date: Wed, 3 Sep 2008 11:10:34 -0700
From: Brad Boyer <flar@allandria.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] m68k: Reverse platform MMU logic so Sun 3 is last
Message-ID: <20080903181034.GA30167@cynthia.pants.nu>
References: <20080903071542.615137611@mail.of.borg> <20080903071741.424551678@mail.of.borg> <20080903073629.GD4104@cs181140183.pp.htv.fi> <1220440421.4159.22.camel@frecb07144>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1220440421.4159.22.camel@frecb07144>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 01:13:41PM +0200, Laurent Vivier wrote:
> Le mercredi 03 septembre 2008 à 10:36 +0300, Adrian Bunk a écrit :
> > Do you have any overview of which m68k platforms still have users?
> 
> At least 4 users for amiga and 2 for mac :-P
> 
> #rank name                            inst  vote   old recent no-files
> 42014 linux-image-2.6-amiga              4     0     0     0     4
> 53844 linux-image-2.6-mac                2     0     0     0     2
> 
> from http://popcon.debian.org/by_inst
> 
> I'm a mac m68k user (who is the other one ???)

I have only Macs, but I still haven't gotten any of them updated
properly to etch-m68k. My Mac IIfx has bad enough disk performance
with the current SCSI driver that I don't do anything more than
try out kernels with a simple root filesystem. My other older
systems are mostly packed away.

It seems like Mac, Amiga, and Atari are the only ones regularly
discussed on the mailing list.

	Brad Boyer
	flar@allandria.com

