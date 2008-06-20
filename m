Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbYFTPko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbYFTPko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbYFTPkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:40:36 -0400
Received: from server.drzeus.cx ([85.8.24.28]:44107 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751744AbYFTPkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:40:35 -0400
Date: Fri, 20 Jun 2008 17:40:30 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: toughen get_ro() and get_cd() return values
Message-ID: <20080620174030.3b563772@mjolnir.drzeus.cx>
In-Reply-To: <20080617141607.GA2712@polina.dev.rtsoft.ru>
References: <20080523154204.GA19803@polina.dev.rtsoft.ru>
	<200806031207.49843.marc.pignat@hevs.ch>
	<20080605144310.GA31596@polina.dev.rtsoft.ru>
	<200806051759.00202.marc.pignat@hevs.ch>
	<20080605171013.GA10513@polina.dev.rtsoft.ru>
	<20080614163640.01e89c51@mjolnir.drzeus.cx>
	<20080617141607.GA2712@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 18:16:07 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> 
> Great, patches follows. Also added missing changes for the at91_mci host.
> Now, I hope, every host is really converted.
> 

Applied the new set, thanks.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Use end-to-end encryption where
  possible.
