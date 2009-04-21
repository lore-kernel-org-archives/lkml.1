Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZDUUhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZDUUhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZDUUg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:36:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZDUUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:36:55 -0400
Subject: Re: [PATCH 12/14] block: replace end_request() with
	[__]blk_end_request_cur()
From: Laurent Vivier <Laurent@lvivier.info>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       Joerg Dorchain <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>, unsik Kim <donari75@gmail.com>
In-Reply-To: <1240331881-28218-13-git-send-email-tj@kernel.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org>
	 <1240331881-28218-13-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 22:35:33 +0200
Message-Id: <1240346133.6812.2.camel@Quad>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/Ie9lYhyw0fYEsuK+I/zM1yERvCX/NcoGM5y7
 OSVgmoFXNHDGBfpPKOnnkACbNsQbDgLhXst8A/spD3VxJlQaTm
 C7TuwshorBCJGrZ6z2UG1Aa1B6CNcga
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Tejun Heo <tj@kernel.org>
...
> Cc: Laurent Vivier <Laurent@lvivier.info>
...
> drivers/block/swim.c            |   14 +++++-----

Acked-by: Laurent Vivier <Laurent@lvivier.info>

Regards,
Laurent

