Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXI2DQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXI2DQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 23:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXI2DQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 23:16:05 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:38338 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbXI2DQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 23:16:04 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 23:16:04 EDT
To: <Wolfgang.Erig@gmx.de>, Erig@fjpop.homelinux.net,
       Wolfgang@fjpop.homelinux.net
Subject: regression in 2.6.23-rc8 - power off failed
Cc: astarikovskiy@suse.de, linux-kernel@vger.kernel.org
References: <20070929005453.GA4475@erig.dyndns.org>
In-reply-To: <20070929005453.GA4475@erig.dyndns.org>
Message-Id: <E1IbSYU-0004dy-S3@faramir.fjphome.nl>
From: Frans Pop <fjp@fjpop.homelinux.net>
Date: Sat, 29 Sep 2007 04:59:46 +0200
X-OriginalArrivalTime: 29 Sep 2007 02:59:47.0900 (UTC) FILETIME=[CBB927C0:01C80244]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> the latest kernel does not power off my system.

This is a known regression in rc8. See this mail and thread for details:
http://lkml.org/lkml/2007/9/25/239

The issue has already been fixed in Linus' git tree.
Please try again with that, or apply the patches included in the posts
referenced in the message linked above.

Cheers,
Frans Pop
