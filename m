Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYBRPYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYBRPYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYBRPYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:24:00 -0500
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:55970 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbYBRPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:23:59 -0500
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: 2.6.25 Regression: DriveStatusError
Date: Mon, 18 Feb 2008 16:23:27 +0100
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802110927.36109.dex@dragonslave.de> <200802112051.45395.bzolnier@gmail.com>
In-Reply-To: <200802112051.45395.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181623.28009.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1203348239;45a48a40;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Bartlomiej Zolnierkiewicz wrote:

> On Monday 11 February 2008, Daniel Exner wrote:
> > Hi!
> >
> > Please CC me as I'm not subscribed to any list, thx in advance.
> >
> > I tried all -git Kernels since begining of cycle and starting when they
> > finaly compiled fine, they weren't able to mount my root.
> >
> > As my laptop with the serial cable is on the run currently I wasn't able
> > to get a trace (perhaps by the we) but error written by hand from screen
> > was this:
> >
> > hda: task_no_data_intr: status=0x51 {DriveReady SeekComplete Error}
> > hda: task_no_data_intr: error=0x04 {DriveStatusError}
> > failed opcode was: 0xe1
>
> [...]
>
> Could you please try 2.6.25-rc1-git1:
>
> http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc1-git1.bz2
Fixed, as is in rc2.

thx 

P.S. (OT)
2.6.25-rc2 gives 200 points more in Geekbench then 2.6.24.x :)

-- 
Greetings
Daniel Exner
