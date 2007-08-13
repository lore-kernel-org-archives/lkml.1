Return-Path: <linux-kernel-owner+w=401wt.eu-S1032807AbXHMStx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032807AbXHMStx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974056AbXHMSe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:34:26 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:39381 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S974494AbXHMSeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:34:24 -0400
Date: Mon, 13 Aug 2007 20:34:22 +0200
From: Martin Mares <mj@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [467/2many] MAINTAINERS - SVGA HANDLING
Message-ID: <mj+md-20070813.183311.30826.nikam@ucw.cz>
References: <46bffc09.olZ/JU6zLi5nghOY%joe@perches.com> <mj+md-20070813.084046.10732.nikam@ucw.cz> <1187028193.10249.197.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187028193.10249.197.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> SVGA HANDLING
> P:	Martin Mares
> M:	mj@ucw.cz
> L:	linux-video@atrey.karlin.mff.cuni.cz
> S:	Maintained
> F:	Documentation/svga.txt
> F:	arch/i386/boot/video.S

Please also kill linux-video and replace it by linux-kernel. Not
a single on-topic mail has arrived to linux-video in a couple of years
and it seems that the list didn't survive update of the list server
a week or so ago.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
War doesn't determine who's right. It determines who's left.
