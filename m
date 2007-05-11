Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXEKJBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXEKJBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXEKJA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:00:58 -0400
Received: from webmail21.mail.yandex.net ([213.180.223.145]:55008 "EHLO
	webmail21.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXEKJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:00:58 -0400
From: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>
To: wankai@sjtu.org
Cc: mchehab@infradead.org, michael@mihu.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l: saa7134: support ir-remote for 10moons TM300
MIME-Version: 1.0
Message-Id: <124811178874048@webmail21.yandex.ru>
Date: Fri, 11 May 2007 13:00:48 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, 2007-05-11 at 11:51 +0400, Nickolay V. Shmyrev wrote:
> > Great, now another correction, sorry for not noticing it before. With
> > correction of bit 0x4 -> 0x2 your remote is exactly the same as 
> > ir_codes_encore_enltv so probably there is sense just to reuse old
> > codes. Elencore mask should be reduced too. I also wonder aren't we
> > talking about the same card here.
> > 
> > 
> It's interesting. I checked the source code, but I don't think that
> Elencore and TM300 is the same card. In fact, they have different tuner
> modules. Or they use the same ir-remote?

Probably just remote is the same.
