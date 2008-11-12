Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYKLOJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYKLOJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 09:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYKLOI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 09:08:59 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:27593 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbYKLOI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 09:08:59 -0500
From: Frans Pop <elendil@planet.nl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 00/49] 2.6.27.5 stable review
Date: Wed, 12 Nov 2008 15:08:55 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
References: <20081112002215.GA10989@kroah.com>
In-reply-To: <20081112002215.GA10989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121508.55791.elendil@planet.nl>
X-OriginalArrivalTime: 12 Nov 2008 14:08:56.0314 (UTC) FILETIME=[336875A0:01C944D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be possible to include the commit below now that it's been 
accepted into mainline?

Thanks,
FJP

commit bf1b36445dc868cbbde194aa1dd87e38fe24cf16
Author: Jonathan McDowell <noodles@earth.li>
Date:   Sat Sep 13 17:08:31 2008 +0100

    kbuild: Fixup deb-pkg target to generate separate firmware deb
