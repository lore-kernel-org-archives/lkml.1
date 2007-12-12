Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbXLLOXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbXLLOXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXLLOWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:22:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44353 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXLLOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:22:54 -0500
Subject: Re: V4L changes broke compilation in 2.6.24-rc5+git
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.SOC.4.64.0712121534210.21442@math.ut.ee>
References: <Pine.SOC.4.64.0712121534210.21442@math.ut.ee>
Content-Type: text/plain; charset=utf-8
Date: Wed, 12 Dec 2007 12:22:35 -0200
Message-Id: <1197469355.4744.23.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qua, 2007-12-12 às 15:37 +0200, Meelis Roos escreveu:
> Got this error on x86-64 from todays git (after the V4L merge):
> ERROR: "videobuf_read_start" [drivers/media/video/videobuf-dvb.ko] undefined!

This changeset fixes the issue.
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=19fb1457990b6b7e15586ec7331541a184233acc

Cheers,
Mauro.

