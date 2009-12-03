Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZLCVZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZLCVZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZLCVZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:25:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55366
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbZLCVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:25:37 -0500
Date: Thu, 03 Dec 2009 13:25:43 -0800 (PST)
Message-Id: <20091203.132543.201642745.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ide: dead/stale code removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <200912032054.49131.bzolnier@gmail.com>
References: <20091203195145.9093.88261.sendpatchset@localhost>
	<200912032054.49131.bzolnier@gmail.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 3 Dec 2009 20:54:49 +0100

> 
> [ uh, this time using the correct file, sorry for the noise ]

Looks better :-)

> Just a small cleanup removing dead/stale code from few IDE host drivers
> (it makes comparisions between old/new drivers and porting fixes in both
> directions much easier).
 ...
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git ide-dcr

Pulled, thanks a lot Bart.
