Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbXKCJ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbXKCJ76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 05:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbXKCJ7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 05:59:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35229 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbXKCJ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 05:59:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472C4685.9060002@s5r6.in-berlin.de>
Date: Sat, 03 Nov 2007 10:59:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc1-git11: Reported regressions from 2.6.23
References: <200711021843.25543.rjw@sisk.pl>
In-Reply-To: <200711021843.25543.rjw@sisk.pl>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list.

Subject		: 2.6.24-rc1-54866... fails to boot: kernel BUG at
		  include/linux/scatterlist.h:49!
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
References	: http://lkml.org/lkml/2007/11/2/240
Handled-By	: Jens Axboe <jens.axboe@oracle.com>
		  Stefan Richter <stefanr@s5r6.in-berlin.de>

-- 
Stefan Richter
-=====-=-=== =-== ---=-
http://arcgraph.de/sr/
