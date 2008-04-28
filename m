Return-Path: <linux-kernel-owner+w=401wt.eu-S966978AbYD1VEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966978AbYD1VEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934865AbYD1VEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:04:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934620AbYD1VEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:04:43 -0400
Date: Mon, 28 Apr 2008 18:03:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428180327.7f6f5204@gaivota>
In-Reply-To: <20080428203056.GI15840@elte.hu>
References: <20080428162421.GA16566@elte.hu>
	<20080428164730.43349c3d@gaivota>
	<20080428203056.GI15840@elte.hu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm working on some changes that will hopefully fix this issue at the 
> > proper way.
> 
> ok, great. FYI, this has been reported months ago too so it's a 
> long-time breakage - would be nice to fix it upstream even if it's the 
> initial fix is a band-aid.

Agreed. Probably, this is broken since 2.6.24, where hybrid tuner support started.

Cheers,
Mauro
