Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbYGATux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbYGATux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYGATun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:50:43 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:39687 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbYGATun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:50:43 -0400
Message-ID: <486A8A92.6050200@oracle.com>
Date: Tue, 01 Jul 2008 12:50:42 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] aio: aio_complete() will never be called in interrupt
 context
References: <200806260930.59836.knikanth@suse.de> <48691B3E.5040402@oracle.com> <200807011359.57164.knikanth@suse.de>
In-Reply-To: <200807011359.57164.knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I did not do any specific testing. Just ran multiple instances of a file-copy 
> utility that uses aio and a bit of Chris Mason's aio-stress.

Are you running these tests under a kernel with lockdep enabled?

> p.s: Is the archives of the linux-aio list available somewhere? The URL in the 
> mail footer seems to be unavailable.

The very first google hit for 'linux-aio mailing list archive' works:

  http://marc.info/?l=linux-aio

- z
