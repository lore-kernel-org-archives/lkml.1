Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbXKLO2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbXKLO2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXKLO2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:28:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36607 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbXKLO2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:28:35 -0500
Subject: Re: [v4l-dvb-maintainer] [RFC: 2.6 patch] remove saa7134-oss
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       DVB ML <linux-dvb@linuxtv.org>
In-Reply-To: <20071109060309.GR26163@stusta.de>
References: <20071109060309.GR26163@stusta.de>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Nov 2007 12:28:21 -0200
Message-Id: <1194877701.8662.109.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Em Sex, 2007-11-09 às 07:03 +0100, Adrian Bunk escreveu:
> The saa7134-oss is deprecated for quite some time, it's the only 
> remaining OSS user outside of sound/oss/, and considering how few and 
> what kind of soundcards are left supported by OSS I hardly see any use 
> cases left.

Since saa7134-alsa seems to do the job, it seems ok to remove
saa7134-oss.

> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>

I'll commit this patch soon at my tree.

Cheers,
Mauro

