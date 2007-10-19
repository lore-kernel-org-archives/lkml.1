Return-Path: <linux-kernel-owner+w=401wt.eu-S936241AbXJSTTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936241AbXJSTTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764160AbXJSTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:19:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56132 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762343AbXJSTTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:19:09 -0400
Date: Fri, 19 Oct 2007 20:19:01 +0100 (BST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jaroslav Kysela <perex@perex.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl
Subject: Re: suspicious ALSA empty commit
In-Reply-To: <Pine.LNX.4.61.0710171928250.11118@tm8103.perex-int.cz>
Message-ID: <Pine.LNX.4.64.0710192017040.12201@pentafluge.infradead.org>
References: <20071016.155044.82377336.davem@davemloft.net>
 <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
 <Pine.LNX.4.61.0710170809580.11118@tm8103.perex-int.cz>
 <alpine.LFD.0.999.0710170854280.26902@woody.linux-foundation.org>
 <Pine.LNX.4.61.0710171928250.11118@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm using stg on top of git for merging and easy tree rebasing, but the
> version might be old (I'll try upgrade at first):
>
> Stacked GIT 0.12
> git version 1.5.0.3
>
> stg import / refresh / pick commands are on way to move patches to linus

with stgit, you should add stg clean on your workflow. This will remove the 
empty commits.

-- 
Cheers,
Mauro
