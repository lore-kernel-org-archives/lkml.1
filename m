Return-Path: <linux-kernel-owner+w=401wt.eu-S1032329AbXEHVVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032329AbXEHVVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032185AbXEHVVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:21:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37219 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031837AbXEHVVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:21:15 -0400
Subject: Re: [PATCH 2/2] V4L: v4l1-compat, fix VIDIOCSPICT for non-OVERLAY
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <26766101783271028925@wsc.cz>
References: <26766101783271028925@wsc.cz>
Content-Type: text/plain; charset=utf-8
Date: Tue, 08 May 2007 18:20:52 -0300
Message-Id: <1178659252.18383.378.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Em Ter, 2007-05-08 às 20:25 +0200, Jiri Slaby escreveu:
> v4l1-compat, fix VIDIOCSPICT for non-OVERLAY
> 
> Do not return EINVAL for devices, which don't support overlay.

The patch bellow also provides a proper fix for VIDIOCSPICT:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=d2af6959d465f0523dceedfddc036c9c5aaf53c0
 
Cheers,
Mauro

