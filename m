Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZIKAd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZIKAd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZIKAd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:33:57 -0400
Received: from kroah.org ([198.145.64.141]:33174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbZIKAd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:33:56 -0400
Date: Thu, 10 Sep 2009 17:31:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 0/4] 2.6.27.34-stable review
Message-ID: <20090911003124.GA12842@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.34 release.
There are 4 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday, September 12, 2009 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.34-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

-------------

 Makefile                 |    2 +-
 drivers/net/e100.c       |    2 +-
 fs/jffs2/wbuf.c          |   10 ++++++++++
 mm/slub.c                |    4 ++--
 net/core/net_namespace.c |    2 +-
 5 files changed, 15 insertions(+), 5 deletions(-)
