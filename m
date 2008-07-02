Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbYGBQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbYGBQie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYGBQi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:38:26 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:49841 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYGBQiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:38:25 -0400
Message-ID: <486BAF01.1040601@oracle.com>
Date: Wed, 02 Jul 2008 09:38:25 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] aio: aio_complete() will never be called in interrupt
 context
References: <200806260930.59836.knikanth@suse.de> <200807011359.57164.knikanth@suse.de> <486A8A92.6050200@oracle.com> <200807021030.43009.knikanth@suse.de>
In-Reply-To: <200807021030.43009.knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes. I have CONFIG_LOCKDEP_SUPPORT=y and did not get any warning messages.

You should mention details like this in the patch descriptions.

> But it would be nice if the link in the mail footer(www.kvack.org/aio) is 
> changed to an active link or removed. The link redirects to 
> www.kvack.org/~blah/aio/ which returns 404

Yeah, it's perhaps not the best that this is still hosted over on Ben's
personal boxes.  I wonder if we should move to linux-aio@vger..

- z
