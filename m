Return-Path: <linux-kernel-owner+w=401wt.eu-S1764333AbXKNT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764333AbXKNT7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbXKNT7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:59:12 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:37669 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbXKNT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:59:11 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 14:59:11 EST
Message-ID: <473B52DB.9050600@hp.com>
Date: Wed, 14 Nov 2007 14:56:11 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, arjan@infradead.org,
       Jens Axboe <jens.axboe@oracle.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>	<20071015114738.6b5a25c7.akpm@linux-foundation.org>	<20071015161315.4fe18e07@bree.surriel.com>	<20071015141236.62b075c6.akpm@linux-foundation.org>	<473B18BA.5000709@hp.com> <20071114091451.d4b110db.akpm@linux-foundation.org> <473B4B53.9090507@hp.com>
In-Reply-To: <473B4B53.9090507@hp.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, and the runs were done in single-user mode...

Alan
