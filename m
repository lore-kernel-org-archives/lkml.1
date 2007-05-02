Return-Path: <linux-kernel-owner+w=401wt.eu-S1766982AbXEBSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766982AbXEBSDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767013AbXEBSDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:03:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40965 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766982AbXEBSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:03:42 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH 36/36] Use menuconfig objects II -
	V4L
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704301430200.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301430200.29151@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=utf-8
Date: Wed, 02 May 2007 15:03:06 -0300
Message-Id: <1178128986.29579.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Em Seg, 2007-04-30 às 14:30 +0200, Jan Engelhardt escreveu:
> Change Kconfig objects from "menu, config" into "menuconfig" so
> that the user can disable the whole feature without having to
> enter the menu first.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Seems OK to me. I'll commit on my tree and ask Linus to pull it with the
next patch series.

I intend also to add one patch to Kconfig, adding a short ---help--- to
the newer variables.

Cheers,
Mauro

