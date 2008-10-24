Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYJXIoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYJXIoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 04:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYJXIoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:44:34 -0400
Received: from nebensachen.de ([195.34.83.29]:36392 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYJXIod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:44:33 -0400
X-Hashcash: 1:20:081024:jens.axboe@oracle.com::ZeZ70snVR4h2OJfM:00000000000000000000000000000000000000008VJy
X-Hashcash: 1:20:081024:lethal@linux-sh.org::4orOxMZx48/R4df+:000000000000000000000000000000000000000000386J
X-Hashcash: 1:20:081024:a.beregalov@gmail.com::FJvk0JzVSZYbLiBi:00000000000000000000000000000000000000001wSe
X-Hashcash: 1:20:081024:tj@kernel.org::Jk/shQxVYepGI8tS:00000pP/
X-Hashcash: 1:20:081024:torvalds@linux-foundation.org::sMEwOntCSUmVkWQg:000000000000000000000000000000004+D4
X-Hashcash: 1:20:081024:linux-kernel@vger.kernel.org::h3XtKClUod0j4IDS:0000000000000000000000000000000003h0d
X-Hashcash: 1:20:081024:linux-ide@vger.kernel.org::y6aCLgm/BdffaPcz:00000000000000000000000000000000000000GY
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, tj@kernel.org,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.27-rc1 (2fca5c): libata: kernel cant boot
References: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com>
	<20081024070955.GN22217@kernel.dk> <20081024071329.GO22217@kernel.dk>
	<20081024071608.GA3879@linux-sh.org>
	<20081024072428.GP22217@kernel.dk>
Date: Fri, 24 Oct 2008 10:44:11 +0200
In-Reply-To: <20081024072428.GP22217@kernel.dk> (Jens Axboe's message of "Fri,
	24 Oct 2008 09:24:29 +0200")
Message-ID: <873aimv0v8.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Fri, 24 Oct 2008 09:22:42 +0200
> Subject: [PATCH] libata: fix bug with non-ncq devices
>
> The recent commit 201f1b98822078c808b5e2d379a6ddbfc0a06ee1 to enable

Wouldn't that be commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e?

Regards,

Elias
