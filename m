Return-Path: <linux-kernel-owner+w=401wt.eu-S933396AbXBETY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbXBETY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933400AbXBETY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:24:27 -0500
Received: from cnc.isely.net ([64.81.146.143]:41291 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396AbXBETY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:24:26 -0500
Date: Mon, 5 Feb 2007 13:24:24 -0600 (CST)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.20] pvrusb2: use ARRAY_SIZE macro when appropriate
 (2)
In-Reply-To: <20070205165333.GB3896@Ahmed>
Message-ID: <Pine.LNX.4.64.0702051319570.19755@cnc.isely.net>
References: <20070205165333.GB3896@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Ahmed S. Darwish wrote:

> Hi all,
> A patch to use ARRAY_SIZE already defined in kernel.h. This patch is
> a complementry (and does not include) the one sent one week earlier.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Ahmed:

After that initial patch a while back I then combed through the entire 
pvrusb2 driver and cleaned up all the other cases.  Those patches should 
already be on a trajectory for 2.6.21.  I'll check it against this patch 
but I think these should already all be handled.

  -Mike


-- 
                        |         Mike Isely          |     PGP fingerprint
     Spammers Die!!     |                             | 03 54 43 4D 75 E5 CC 92
                        |   isely @ pobox (dot) com   | 71 16 01 E2 B5 F5 C1 E8
                        |                             |
