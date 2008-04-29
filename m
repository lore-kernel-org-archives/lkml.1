Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbYD2UFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbYD2UFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbYD2UFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:05:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbYD2UFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:05:12 -0400
Date: Tue, 29 Apr 2008 17:03:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix SOC_CAMERA_MT9M001 build bug
Message-ID: <20080429170344.5a6d01bc@gaivota>
In-Reply-To: <Pine.LNX.4.64.0804291345050.5602@axis700.grange>
References: <20080428120032.GA23847@elte.hu>
	<Pine.LNX.4.64.0804281944100.10718@axis700.grange>
	<20080428193130.GC9907@elte.hu>
	<Pine.LNX.4.64.0804282138000.11449@axis700.grange>
	<20080428201105.GD15840@elte.hu>
	<Pine.LNX.4.64.0804291345050.5602@axis700.grange>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 13:48:21 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Mon, 28 Apr 2008, Ingo Molnar wrote:
> 
> > sorry, you are right. Mind doing the right patch as you know this code 
> > much better than i do?
> 
> Mauro, as you've already committed Ingo's patch to your hg tree, what's 
> the best way to fix this? Should a revert be committed, or would you drop 
> that patch? The latter would be better, I guess, but then I better wait 
> for you to do it, then update against your new tree, and then add a 
> correct fix, right?

Send me a pull request with a patch reverting it and applying the proper one.
I'll drop it from my patch series at -git.


Cheers,
Mauro
