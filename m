Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbXH2RcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbXH2RcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXH2RcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:32:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34628 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbXH2RcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:32:05 -0400
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] video-buf.c: remove dead code
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070827212837.GB4121@stusta.de>
References: <20070827212837.GB4121@stusta.de>
Content-Type: text/plain; charset=utf-8
Date: Wed, 29 Aug 2007 14:31:51 -0300
Message-Id: <1188408711.12645.4.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian,

Em Seg, 2007-08-27 às 23:28 +0200, Adrian Bunk escreveu:
> This patch removes code that was both dead and pointless.

I've already handled this on my newer videobuf approach:

http://linuxtv.org/hg/~mchehab/videobuf/

Those patches are currently in tests. I expect to have those ready for
2.6.24.
 
Cheers,
Mauro

