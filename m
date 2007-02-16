Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbXBPXWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbXBPXWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbXBPXWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:22:19 -0500
Received: from stingr.net ([212.193.32.15]:56673 "EHLO stingr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbXBPXWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:22:18 -0500
X-Greylist: delayed 794 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 18:22:18 EST
Date: Sat, 17 Feb 2007 02:08:54 +0300
From: Paul P Komkoff Jr <i@stingr.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Add .splice_read to sockets?
Message-ID: <20070216230854.GX32467@stingr.net>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Agent Darien Fawkes
X-Mailer: Intel Ultra ATA Storage Driver
X-RealName: Stingray Greatest Jr
Organization: Department of Fish & Wildlife
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is there any plans to make splice(socket, ..., pipe, ...) work?

Thanks!

-- 
Paul P 'Stingray' Komkoff Jr // http://stingr.net/key <- my pgp key
 This message represents the official view of the voices in my head
