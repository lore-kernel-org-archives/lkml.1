Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbXEKJ0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbXEKJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXEKJ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:26:06 -0400
Received: from mail.sjtu.org ([202.120.5.34]:27110 "ehlo appsrv1.sjtu.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752969AbXEKJ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:26:05 -0400
Subject: Re: [PATCH] v4l: saa7134: support ir-remote for 10moons TM300
From: Tony Wan <wankai@sjtu.org>
To: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
Cc: mchehab@infradead.org, michael@mihu.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <124811178874048@webmail21.yandex.ru>
References: <124811178874048@webmail21.yandex.ru>
Content-Type: text/plain
Date: Fri, 11 May 2007 17:23:16 +0800
Message-Id: <1178875396.5020.15.camel@wankai.sjtu.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 13:00 +0400, Nickolay V. Shmyrev wrote:
> Probably just remote is the same.

Thanks for you correction.
So, if I set the mask_keycode to "0x5f80000", all the key codes of TM300
will be exactly same as Encore's boards. Then the remote will work with
a small patch applied.
I'll test it later.

